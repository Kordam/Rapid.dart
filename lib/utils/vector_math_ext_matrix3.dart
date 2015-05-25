part of rapid;

//Computes eigen vectors and eigen values from a 3x3 symmetric [matrix]
void Matrix3_compute_symmetric_eigen(Matrix3 matrix, Matrix3 eigvecs, Vector3 eigvals)
{
  Vector3 tmp = new Vector3.zero();
  matrix.copyInto(eigvecs);
  tred2(eigvecs, eigvals, tmp);
  tql2(eigvecs, eigvals, tmp);
}

double hypot2(double x, double y)
{
  return sqrt(x*x+y*y);
}

// Symmetric tridiagonal QL algorithm.
void tql2(Matrix3 V, Vector3 d, Vector3 e)
{
  for (int i = 1; i < 3; i++) {
    e[i-1] = e[i];
  }
  e[3-1] = 0.0;

  double f = 0.0;
  double tst1 = 0.0;
  double eps = pow(2.0,-52.0);
  for (int l = 0; l < 3; l++) {
// Find small subdiagonal element
    tst1 = max(tst1,(d[l]).abs() + (e[l]).abs());
    int m = l;
    while (m < 3) {
      if (e[m].abs() <= eps*tst1) {
        break;
      }
      m++;
    }

// If m == l, d[l] is an eigenvalue,
// otherwise, iterate.
    if (m > l) {
      int iter = 0;
      do {
        iter = iter + 1;  // (Could check iteration count here.)

// Compute implicit shift
        double g = d[l];
        double p = (d[l+1] - g) / (2.0 * e[l]);
        double r = hypot2(p,1.0);
        if (p < 0) {
          r = -r;
        }
        d[l] = e[l] / (p + r);
        d[l+1] = e[l] * (p + r);
        double dl1 = d[l+1];
        double h = g - d[l];
        for (int i = l+2; i < 3; i++) {
          d[i] -= h;
        }
        f = f + h;

// Implicit QL transformation.
        p = d[m];
        double c = 1.0;
        double c2 = c;
        double c3 = c;
        double el1 = e[l+1];
        double s = 0.0;
        double s2 = 0.0;
        for (int i = m-1; i >= l; i--) {
          c3 = c2;
          c2 = c;
          s2 = s;
          g = c * e[i];
          h = c * p;
          r = hypot2(p,e[i]);
          e[i+1] = s * r;
          s = e[i] / r;
          c = p / r;
          p = c * d[i] - s * g;
          d[i+1] = h + s * (c * g + s * d[i]);

// Accumulate transformation.
          for (int k = 0; k < 3; k++) {
            h = V.getRow(k)[i+1];
            V.setEntry(k, i+1, s * V.getRow(k)[i] + c * h);
            V.setEntry(k, i, c * V.getRow(k)[i] - s * h);
          }
        }
        p = -s * s2 * c3 * el1 * e[l] / dl1;
        e[l] = s * p;
        d[l] = c * p;

// Check for convergence.
      } while ((e[l]).abs() > eps*tst1);
    }
    d[l] = d[l] + f;
    e[l] = 0.0;
  }

// Sort eigenvalues and corresponding vectors.
  for (int i = 0; i < 3-1; i++) {
    int k = i;
    double p = d[i];
    for (int j = i+1; j < 3; j++) {
      if (d[j] < p) {
        k = j;
        p = d[j];
      }
    }
    if (k != i) {
      d[k] = d[i];
      d[i] = p;
      for (int j = 0; j < 3; j++) {
        p = V.getRow(j)[i];
        V.setEntry(j, i, V.getRow(j)[k]);
        V.setEntry(j, k, p);
      }
    }
  }
}


// Symmetric Householder reduction to tridiagonal form.
void tred2(Matrix3 V, Vector3 d, Vector3 e) {
  for (int j = 0; j < 3; j++) {
    d[j] = V.getRow(3-1)[j];
  }
// Householder reduction to tridiagonal form.
  for (int i = 3-1; i > 0; i--) {
// Scale to avoid under/overflow.
    double scale = 0.0;
    double h = 0.0;
    for (int k = 0; k < i; k++) {
      scale = scale +d[k].abs();
    }
    if (scale == 0.0) {
      e[i] = d[i-1];
      for (int j = 0; j < i; j++) {
        d[j] = V.getRow(i-1)[j];
        V.setEntry(i, j, 0.0);
        V.setEntry(j, i, 0.0);
      }
    }
    else {
// Generate Householder vector.
      for (int k = 0; k < i; k++) {
        d[k] /= scale;
        h += d[k] * d[k];
      }
      double f = d[i-1];
      double g = sqrt(h);
      if (f > 0) {
        g = -g;
      }
      e[i] = scale * g;
      h = h - f * g;
      d[i-1] = f - g;
      for (int j = 0; j < i; j++) {
        e[j] = 0.0;
      }

// Apply similarity transformation to remaining columns.
      for (int j = 0; j < i; j++) {
        f = d[j];
        V.setEntry(j, i, f);
        g = e[j] + V.getRow(j)[j] * f;
        for (int k = j+1; k <= i-1; k++) {
          g += V.getRow(k)[j] * d[k];
          e[k] += V.getRow(k)[j] * f;
        }
        e[j] = g;
      }
      f = 0.0;
      for (int j = 0; j < i; j++) {
        e[j] /= h;
        f += e[j] * d[j];
      }
      double hh = f / (h + h);
      for (int j = 0; j < i; j++) {
        e[j] -= hh * d[j];
      }
      for (int j = 0; j < i; j++) {
        f = d[j];
        g = e[j];
        for (int k = j; k <= i-1; k++) {
          V.setEntry(k, j, V.getRow(k)[j] - (f * e[k] + g * d[k]));
        }
        d[j] = V.getRow(i-1)[j];
        V.setEntry(i, j, 0.0);
      }
    }
    d[i] = h;
  }

// Accumulate transformations.
  for (int i = 0; i < 3-1; i++) {
    V.setEntry(3-1, i, V.getRow(i)[i]);
    V.setEntry(i, i, 1.0);
    double h = d[i+1];
    if (h != 0.0) {
      for (int k = 0; k <= i; k++) {
        d[k] = V.getRow(k)[i+1] / h;
      }
      for (int j = 0; j <= i; j++) {
        double g = 0.0;
        for (int k = 0; k <= i; k++) {
          g += V.getRow(k)[i+1] * V.getRow(k)[j];
        }
        for (int k = 0; k <= i; k++) {
          V.setEntry(k, j, V.getRow(k)[j] - g * d[k]);
        }
      }
    }
    for (int k = 0; k <= i; k++) {
      V.setEntry(k, i+1, 0.0);
    }
  }
  for (int j = 0; j < 3; j++) {
    d[j] = V.getRow(3-1)[j];
    V.setEntry(3-1, j, 0.0);
  }
  V.setEntry(3-1, 3-1, 1.0);
  e[0] = 0.0;
}