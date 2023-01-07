#include <stdlib.h>

#define d(i,j) dd[(i) * (m+2) + (j) ]
#define min(x,y) ((x) < (y) ? (x) : (y))
#define min3(a,b,c) ((a)< (b) ? min((a),(c)) : min((b),(c)))
#define min4(a,b,c,d) ((a)< (b) ? min3((a),(c),(d)) : min3((b),(c),(d)))

int dldist2(char *s, char* t, int n, int m) {
    int *dd;
    int i, j, cost, i1,j1,DB;
    int INFINITYY = n + m;
    int DA[256 * sizeof(int)];

    memset(DA, 0, sizeof(DA));

    if (!(dd = (int*) malloc((n+2)*(m+2)*sizeof(int)))) {
      return -1;
    }

    d(0,0) = INFINITYY;
    for(i = 0; i < n+1; i++) {
      d(i+1,1) = i ;
      d(i+1,0) = INFINITYY;
    }
    for(j = 0; j<m+1; j++) {
      d(1,j+1) = j ;
      d(0,j+1) = INFINITYY;
    }

    for(i = 1; i< n+1; i++) {
      DB = 0;
      for(j = 1; j< m+1; j++) {
        i1 = DA[t[j-1]];
        j1 = DB;
        cost = ((s[i-1]==t[j-1])?0:1);
        if(cost==0) DB = j;
        d(i+1,j+1) =
          min4(d(i,j)+cost,
              d(i+1,j) + 1,
              d(i,j+1)+1, 
              d(i1,j1) + (i-i1-1) + 1 + (j-j1-1));
      }
      DA[s[i-1]] = i;
    }
    cost = d(n+1,m+1);
    free(dd);
    return cost;
}
