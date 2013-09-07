#define  WITHOUT_CAIRO
#include "genometools.h"

// Compile as follows:
// gcc -Wall -O3 -g -I /usr/local/include/genometools -o select select.c -lgenometools

// Usage: ./select annot1.gff3 [annot2.gff3 ...]

bool meets_criteria(GtFeatureNode *mrna)
{
  if(mrna == NULL)
    return false;

  if(gt_feature_node_has_type(mrna, "mRNA") == false)
    return false;

  GtFeatureNodeIterator *iter = gt_feature_node_iterator_new_direct(mrna);
  GtFeatureNode *child;
  unsigned long numexons = 0;
  unsigned long totalexonlength = 0;
  unsigned long secondexonlength;
  for(child  = gt_feature_node_iterator_next(iter);
      child != NULL;
      child  = gt_feature_node_iterator_next(iter))
  {
    if(gt_feature_node_has_type(child, "exon"))
    {
      GtGenomeNode *gn = (GtGenomeNode *)child;
      unsigned long exonlength = gt_genome_node_get_length(gn);
      totalexonlength += exonlength;
      numexons++;
      if(numexons == 2)
        secondexonlength = exonlength;
    }
  }
  gt_feature_node_iterator_delete(iter);

  bool numexoncriterion = (numexons == 3);
  bool secondexonlengthcriterion = (secondexonlength > 150);
  bool totallengthcriterion = (totalexonlength - secondexonlength > 500);
  if(numexoncriterion && secondexonlengthcriterion && totallengthcriterion)
    return true;

  return false;
}

int main(int argc, const char **argv)
{
  GtArray *features;
  GtError *error;
  GtFile *outstream;
  GtNodeStream *gff3, *featstream;
  GtNodeVisitor *out;

  gt_lib_init();
  error = gt_error_new();
  gff3 = gt_gff3_in_stream_new_unsorted(argc - 1, argv + 1);
  gt_gff3_in_stream_check_id_attributes((GtGFF3InStream *)gff3);
  gt_gff3_in_stream_enable_tidy_mode((GtGFF3InStream *)gff3);
  features = gt_array_new( sizeof(GtGenomeNode *) );
  featstream = gt_array_out_stream_new(gff3, features, error);

  int result = gt_node_stream_pull(featstream, error);
  if(result == -1)
  {
    fprintf(stderr, "error loading data into memory: %s\n",
            gt_error_get(error));
    return 1;
  }

  outstream = gt_file_new_from_fileptr(stdout);
  out = gt_gff3_visitor_new(outstream);
  gt_gff3_visitor_retain_id_attributes((GtGFF3Visitor *)out);

  gt_array_reverse(features);
  while(gt_array_size(features) > 0)
  {
    GtGenomeNode **gn = gt_array_pop(features);
    GtFeatureNode *fn = gt_feature_node_try_cast(*gn);
    if(fn == NULL)
    {
      gt_genome_node_delete(*gn);
      continue;
    }

    GtFeatureNodeIterator *iter = gt_feature_node_iterator_new(fn);
    GtFeatureNode *current;
    for(current  = gt_feature_node_iterator_next(iter);
        current != NULL;
        current  = gt_feature_node_iterator_next(iter))
    {
      if(meets_criteria(current))
      {
        GtGenomeNode *currentgn = (GtGenomeNode *)current;
        int outresult = gt_genome_node_accept(currentgn, out, error);
        if(outresult == -1)
        {
          fprintf(stderr, "error printing GFF3: %s\n", gt_error_get(error));
          return 1;
        }
      }
    }
    gt_feature_node_iterator_delete(iter);
    gt_genome_node_delete(*gn);
  }

  gt_array_delete(features);
  gt_error_delete(error);
  gt_file_delete_without_handle(outstream);
  gt_node_stream_delete(gff3);
  gt_node_stream_delete(featstream);
  gt_node_visitor_delete(out);

  gt_lib_clean();
  return 0;
}

