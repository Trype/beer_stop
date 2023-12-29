sealed class Categories{}

class Wine extends Categories{
  static String get name => "Wine";
}

class BeerCider extends Categories{
  static String get name => "Beer & Cider";
}

class Spirits extends Categories{
  static String get name => "Spirits";
}

class Coolers extends Categories{
  static String get name => "Coolers";
}