=head1 LICENSE

Copyright [2018-2019] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Bio::EnsEMBL::DataCheck::Checks::CheckOrthologyQCThresholds;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME           => 'CheckOrthologyQCThresholds',
  DESCRIPTION    => 'Check that some wga_coverage and goc_score thresholds have been populated',
  GROUPS         => ['compara', 'compara_protein_trees'],
  DATACHECK_TYPE => 'critical',
  DB_TYPES       => ['compara'],
  TABLES         => ['method_link_species_set_attr']
};

sub tests {
  my ($self) = @_;
  my $dbc = $self->dba->dbc;
  my @thresholds = qw( goc_quality_threshold wga_quality_threshold );

  foreach my $threshold ( @thresholds ) {
    my $desc = "There are some $threshold in method_link_species_set_attr";
    my $sql = qq/
      SELECT COUNT(*) 
        FROM method_link_species_set_attr 
      WHERE $threshold IS NOT NULL
    /;
    is_rows_nonzero( $dbc, $sql, $desc );
  }

}

1;

