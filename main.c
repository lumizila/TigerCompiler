/* main.cc */
/*#include <cstdlib>
*/
#include "heading.h"


// prototype of bison-generated parser function
int yyparse();

int main(int argc, char **argv)
{
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
	
/*    cout << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
 */
   fprintf(stderr, "Arquivo %s nao pode ser aberto.\n", argv[1]);
   exit( 1 );
  }
  
  yyparse();
  return 0;
}

