/* Do not edit this file - Generated by Perlito5 9.0 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Some::Thing PACKAGE = Some::Thing
void foo ()
PPCODE:
    warn( SvPVx_nolen( newSVpv("MOO", 0)) );




