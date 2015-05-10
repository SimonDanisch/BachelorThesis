###############################################################################################
#hello world
###############################################################################################
#include <iostreams>
int main() {
  std::cout << "Goodbye, World!";
}
#include <boost/numeric/ublas/matrix.hpp>
int main()
{
    using namespace boost::numeric::ublas;
    int nSize = 3;
    identity_matrix<int> oMatrix( nSize );
    for ( unsigned int y = 0; y < oMatrix.size2(); y++ )
    {
        for ( unsigned int x = 0; x < oMatrix.size1(); x++ )
        {
            std::cout << oMatrix(x,y) << " ";
        }
        std::cout << std::endl;
    }
    return 0;
}
###############################################################################################
#reverse words
###############################################################################################
#include <string>
#include <iostream>
using namespace std;
string invertString( string s )
{
    string st, tmp;
    for( string::iterator it = s.begin(); it != s.end(); it++ )
    {
        if( *it != 32 ) tmp += *it;
        else
        {
            st = " " + tmp + st;
            tmp.clear();
        }
    }
    return tmp + st;
}
 
int main( int argc, char* argv[] )
{
    string str[] = {};
    for( int i = 0; i < 10; i++ )
        cout << invertString( str[i] ) << "\n";
    cout << "\n";
    return system( "pause" );
}