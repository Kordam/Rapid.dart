part of rapid;

Obb3 Obb3_fitFromCovarianceMatrix(Matrix3 cov, List<Vector3> points)
{

}

Obb3 Obb3_fitFromPoints(List<Vector3> points)
{
  Vector3 m = new Vector3(0.0, 0.0, 0.0);
  Matrix3 cov = new Matrix3.zero();

  //Find the mean point
  points.forEach((p) => m += p);
  m /= points.length.toDouble();

  //Compute the covariance matrix
  double cxx = 0.0, cxy = 0.0, cxz = 0.0,
         cyy = 0.0, cyz = 0.0, czz = 0.0;
  points.forEach((p) {
    cxx += p[0] * p[0] - m[0] * m[0];
    cxy += p[0] * p[1] - m[0] * m[1];
    cxz += p[0] * p[2] - m[0] * m[2];
    cyy += p[1] * p[1] - m[1] * m[1];
    cyz += p[1] * p[2] - m[1] * m[2];
    czz += p[2] * p[2] - m[2] * m[2];
  });

  cov.setValues(cxx, cxy, cxz,
                cxy, cyy, cyz,
                cxz, cyz, czz);

  return Obb3_fitFromCovarianceMatrix(cov, points);
}

void Matrix3_QR_gram_schmidt(Matrix3 matrix, Matrix3 Q, Matrix3 R)
{
}

void Matrix3_QR_householder(Matrix3 matrix, Matrix3 Q, Matrix3 R)
{
}

void Matrix3_QR_algo_shifts(Matrix3 matrix, Matrix3 eigvecs, Vector3 eigvals)
{
}

void Matrix3_QR_algo_symmetric(Matrix3 matrix, Matrix3 eigvecs, Vector3 eigvals)
{
}