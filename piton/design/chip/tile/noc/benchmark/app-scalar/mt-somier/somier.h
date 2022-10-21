
extern void init_forloop_boundries (int cid,int nc, int dim );
extern void acceleration(int cid, int nc, int n, double (*A)[n][n][n], double (*F)[n][n][n], double M);
extern void velocities(int cid, int nc, int n, double (*V)[n][n][n], double (*A)[n][n][n], double dt);
extern void positions(int cid, int nc, int n, double (*X)[n][n][n], double (*V)[n][n][n], double dt);
extern void compute_stats(int cid, int nc, int n, double (*X)[n][n][n], double Xcenter[3]);
extern void force_contribution(int cid, int nc, int n, double (*X)[n][n][n], double (*F)[n][n][n],
                   int i, int j, int k, int neig_i, int neig_j, int neig_k);
extern void compute_forces(int cid, int nc, int n, double (*X)[n][n][n], double (*F)[n][n][n]);

extern void compute_stats_pre(int cid, int nc, int n, double (*X)[n][n][n]);


extern double M;
extern double dt;
extern double spring_K;
