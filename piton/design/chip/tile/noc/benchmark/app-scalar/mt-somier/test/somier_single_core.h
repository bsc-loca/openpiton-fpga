extern void acceleration_single(int n, double (*A)[n][n][n], double (*F)[n][n][n], double M);
extern void velocities_single( int n, double (*V)[n][n][n], double (*A)[n][n][n], double dt);
extern void positions_single( int n, double (*X)[n][n][n], double (*V)[n][n][n], double dt);
extern void compute_stats_single( int n, double (*X)[n][n][n], double Xcenter[3]);
extern void force_contribution_single( int n, double (*X)[n][n][n], double (*F)[n][n][n],
                   int i, int j, int k, int neig_i, int neig_j, int neig_k);
extern void compute_forces_single( int n, double (*X)[n][n][n], double (*F)[n][n][n]);

extern void compute_stats_pre_single( int n, double (*X)[n][n][n]);

extern double M;
extern double dt;
extern double spring_K;
