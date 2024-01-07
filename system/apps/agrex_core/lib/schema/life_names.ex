defmodule Agrex.Schema.LifeNames do
  @female_names [
    "Anna",
    "Alicia",
    "Aria",
    "Bella",
    "Bea",
    "Bo",
    "Charlotte",
    "Cassie",
    "Cecile",
    "Celine",
    "Chloe",
    "Danielle",
    "Dolly",
    "Donna",
    "Eleanor",
    "Edie",
    "Ellie",
    "Elsie",
    "Fanny",
    "Flora",
    "Gerda",
    "Gudrun",
    "Hilda",
    "Hortence",
    "Irene",
    "Indy",
    "Joan",
    "Jenny",
    "Karen",
    "Katie",
    "Linda",
    "Laura",
    "Mindy",
    "Mona",
    "Nora",
    "Nadine",
    "Ola",
    "Ona",
    "Paula",
    "Pinta",
    "Rona",
    "Rennie",
    "Sindy",
    "Sonnie",
    "Stephie",
    "Sandra",
    "Tinny",
    "Tanny",
    "Ursula",
    "Umma",
    "Vicky",
    "Victoria",
    "Wikkie",
    "Wonda",
    "Wilma",
    "Yula",
    "Yvette",
    "Yvie",
    "Yvonne",
    "Zora",
    "Zulma"
  ]

  @skin_colors ["Amber", "Brown", "Black", "Blue", "Red", "White"]
  @skin_patterns ["Spotted", "Speckled", "Flamed", "Striped", "Plain"]
  @characters ["Happy", "Sad", "Dumb", "Smart", "Wild", "Calm"]

  @male_names [
    "Andy",
    "Andre",
    "Anatol",
    "Anton",
    "Boris",
    "Bart",
    "Benny",
    "Charles",
    "Clement",
    "Danny",
    "Dirk",
    "Ebenezer",
    "Eddy",
    "Elmo",
    "Edward",
    "Erwin",
    "Frank",
    "Fons",
    "Fred",
    "Felix",
    "Fritz",
    "George",
    "Gerard",
    "Gustav",
    "Hans",
    "Heinz",
    "Hubert",
    "Irwin",
    "Ian",
    "Iwan",
    "John",
    "Jack",
    "Jonas",
    "Karl",
    "Kenny",
    "Kevin",
    "Lucas",
    "Lemmy",
    "Mike",
    "Mark",
    "Miro",
    "Nick",
    "Norm",
    "Oscar",
    "Oliver",
    "Ozzy",
    "Paul",
    "Phil",
    "Ringo",
    "Rick",
    "Raf",
    "Ronny",
    "Steph",
    "Stan",
    "Trevor",
    "Theo",
    "Vick",
    "Vlad",
    "Wiktor",
    "Wodan",
    "Zeus"
  ]

  def random_name("male"),
    do:
      Enum.random(@characters) <>
        " " <>
        Enum.random(@skin_colors) <>
        " " <>
        Enum.random(@skin_patterns) <>
        " " <>
        Enum.random(@male_names)

  def random_name("female"),
    do:
      Enum.random(@characters) <>
        " " <>
        Enum.random(@skin_colors) <>
        " " <>
        Enum.random(@skin_patterns) <>
        " " <>
        Enum.random(@female_names)
        
end
