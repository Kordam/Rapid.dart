part of rapid;

const double EPSILON = 1e-5;
const double M_PI = 3.14159265359;
double TO_RADIAN(double x) => x * (M_PI / 180.0);
double TO_DEGREE(double x) => x * (180.0 / M_PI);
double NEAR_ZERO(double x) => x <= EPSILON && x >= -EPSILON ? 0.0 : x;