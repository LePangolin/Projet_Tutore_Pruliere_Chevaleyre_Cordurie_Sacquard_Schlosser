// Classe basée sur la logique 'pseudo random number generator'
// Permet de générer des nombres aléatoires à partir d'un seed

class PseudoRandomNG {
  int seed;

  PseudoRandomNG(this.seed);

  int next() {
    seed = (1103515245 * seed + 12345) % 2147483647;
    return seed;
  }

  bool getBoolean(int numerator, int denominator) {
    int randomNumber = next() % denominator;
    return randomNumber < numerator;
  }
}
