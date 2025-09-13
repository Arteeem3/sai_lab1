% пол
male(aleksei).
male(gennadiy).
male(vovik).
male(kolya).
male(sasha).
male(artem).
male(makar).
male(oleg).
male(nikolai).
male(viktor).
male(vova).
male(yura).
male(emil).
male(volodya).
male(lenya).
male(andrey).
male(igor).
male(vadik).
male(anton).
male(valera).

female(lyda).
female(nina).
female(tanya).
female(larisa_z).
female(galya).
female(lida).
female(zina).
female(larisa_s).
female(valya).
female(lena).

% домашние животные
pet(grunya).
pet(musya).
pet(timka).
pet(rey).
pet(izumka).

% владельцы домашних животных
owner(larisa_z, grunya).
owner(larisa_z, musya).
owner(larisa_z, rey).
owner(larisa_z, timka).
owner(artem, izumka).

% родители и дети
parent(lyda, vovik).
parent(lyda, kolya).
parent(gennadiy, sasha).
parent(gennadiy, tanya).
parent(nina, sasha).
parent(nina, tanya).
parent(tanya, artem).
parent(tanya, makar).
parent(oleg, artem).
parent(oleg, makar).
parent(larisa_z, oleg).
parent(larisa_z, galya).
parent(nikolai, oleg).
parent(nikolai, galya).
parent(lida, yura).
parent(lida, emil).
parent(lida, volodya).
parent(lida, lenya).
parent(zina, andrey).
parent(zina, igor).
parent(larisa_s, vadik).
parent(larisa_s, lena).
parent(valya, anton).
parent(valya, valera).

sibling(gennadiy, lyda).
sibling(gennadiy, aleksei).
sibling(aleksei, lyda).
sibling(nikolai, viktor).
sibling(nikolai, lida).
sibling(nikolai, zina).
sibling(nikolai, larisa_s).
sibling(nikolai, valya).
sibling(viktor, lida).
sibling(viktor, zina).
sibling(viktor, larisa_s).
sibling(viktor, valya).
sibling(lida, zina).
sibling(lida, larisa_s).
sibling(lida, valya).
sibling(zina, larisa_s).
sibling(zina, valya).
sibling(larisa_s, valya).

% браки (год заключения брака)
married(gennadiy, nina, 1979).
married(nikolai, larisa_z, 1969).
married(oleg, tanya, 2004).
married(vova, galya, 1991).


% годы рождения и смерти
born(gennadiy, 1952).
born(vovik, 1974).
born(kolya, 1974).
born(sasha, 1980).
born(artem, 2005).
born(makar, 2011).
born(oleg, 1973).
born(viktor, 1953).
born(yura, 1980).
born(emil, 1975).
born(volodya, 1975).
born(lenya, 1983).
born(andrey, 1981).
born(igor, 1981).
born(vadik, 1974).
born(anton, 1977).
born(valera, 1984).
born(lyda, 1952).
born(tanya, 1980).
born(larisa_z, 1950).
born(galya, 1972).
born(lida, 1953).
born(zina, 1953).
born(larisa_s, 1955).
born(valya, 1955).
born(lena, 1978).
born(grunya, 2010).
born(rey, 2010).
born(musya, 2025).

born(aleksei, 1952).
born(nikolai, 1945).
born(vova, 1960).
born(nina, 1958).
born(timka, 2012).

died(aleksei, 2024).
died(nikolai, 2013).
died(vova, 2000).
died(nina, 2008).
died(timka, 2024).

% правила

% 1. Является ли человек родителем в определенном году
parent_in_year(Parent, Child, Year) :-
    parent(Parent, Child),
    born(Child, ChildYear),
    ChildYear =< Year,
    (died(Parent, DeathYear) -> DeathYear >= Year; true).

% 2. Жив ли человек в определённом году
alive_in(Person, Year) :-
    born(Person, BirthYear),
    BirthYear =< Year,
    (died(Person, DeathYear) -> DeathYear >= Year; true).

% 3. Действителен ли брак в определённом году
married_in_year(Husband, Wife, Year) :-
    married(Husband, Wife, MarriageYear),
    MarriageYear =< Year,
    alive_in(Husband, Year),
    alive_in(Wife, Year).

% 4. Возраст человека в определённом году
age_in(Person, Year, Age) :-
    born(Person, BirthYear),
    Age is Year - BirthYear,
    Age >= 0,
    alive_in(Person, Year).

% 5. Является ли человек вдовцом/вдовой в определённом году
widow_in_year(Person, Year) :-
    married(Person, Spouse, _),
    died(Spouse, DeathYear),
    DeathYear =< Year,
    alive_in(Person, Year).

% 6. Являются ли два человека братьями или сёстрами
siblings(Person1, Person2) :-
    parent(Parent, Person1),
    parent(Parent, Person2),
    Person1 \= Person2.

% 7. Являются ли два человека двоюродными братьями/сёстрами
cousins(Person1, Person2) :-
    parent(Parent1, Person1),
    parent(Parent2, Person2),
    siblings(Parent1, Parent2).

% 8. Является ли человек дядей или тётей
aunt_uncle(AuntUncle, Person) :-
    parent(Parent, Person),
    siblings(AuntUncle, Parent).

% 9. Является ли человек прародителем
grandparent(Grandparent, Person) :-
    parent(Grandparent, Parent),
    parent(Parent, Person).

% 10. Является ли человек потомком
descendant(Descendant, Ancestor) :-
    parent(Ancestor, Intermediate),
    descendant(Descendant, Intermediate).

% 11. Является ли человек предком
ancestor(Ancestor, Descendant) :-
    descendant(Descendant, Ancestor).

% 12. Родился ли человек до определённого года
born_before(Person, Year) :-
    born(Person, BirthYear),
    BirthYear < Year.

% 13. Умер ли человек до определённого года
died_before(Person, Year) :-
    died(Person, DeathYear),
    DeathYear < Year.

% 14. Является ли человек совершеннолетним в определённом году
adult_in_year(Person, Year) :-
    age_in(Person, Year, Age),
    Age >= 18.

% 15. Является ли человек несовершеннолетним в определённом году
minor_in_year(Person, Year) :-
    age_in(Person, Year, Age),
    Age < 18.

% 16. Является ли человек пенсионером в определённом году (возраст >= 60)
pensioner_in_year(Person, Year) :-
    age_in(Person, Year, Age),
    Age >= 60.

% 17. Является ли человек главой семьи
family_head(Person) :-
    male(Person),
    has_children(Person),
    married(Person, _, _).

% 18. Есть ли у человека дети
has_children(Person) :-
    parent(Person, _).

% 19. Являются ли два человека кровными родственниками
blood_relative(Person1, Person2) :-
    ancestor(Ancestor, Person1),
    ancestor(Ancestor, Person2).

% 20. Является ли человек единственным ребёнком
only_child(Person) :-
    \+ siblings(Person, _).

% 21. Является ли человек близнецом
twin(Person) :-
    siblings(Person, Sibling),
    born(Person, Year),
    born(Sibling, Year),
    Person \= Sibling.

% 22. Является ли семья полной (оба родителя живы и в браке)
complete_family(Parent1, Parent2, Child, Year) :-
    parent(Parent1, Child),
    parent(Parent2, Child),
    married_in_year(Parent1, Parent2, Year),
    alive_in(Parent1, Year),
    alive_in(Parent2, Year).

% 23. Является ли семья неполной
incomplete_family(Parent, Child, Year) :-
    parent(Parent, Child),
    \+ complete_family(_, _, Child, Year).

% 24. Является ли человек старшим в семье
eldest_in_family(Person) :-
    siblings(Person, _),
    \+ (siblings(Person, Sibling), born(Sibling, YearS), born(Person, YearP), YearS < YearP).

% 25. Является ли человек младшим в семье
youngest_in_family(Person) :-
    siblings(Person, _),
    \+ (siblings(Person, Sibling), born(Sibling, YearS), born(Person, YearP), YearS > YearP).

% 26. Является ли человек тёщей или свекровью
mother_in_law(MotherInLaw, Person) :-
    married(Person, Spouse, _),
    parent(MotherInLaw, Spouse),
    female(MotherInLaw).

% 27. Является ли человек тестем или свёкром
father_in_law(FatherInLaw, Person) :-
    married(Person, Spouse, _),
    parent(FatherInLaw, Spouse),
    male(FatherInLaw).

% 28. Является ли человек зятем
son_in_law(SonInLaw, Parent) :-
    married(SonInLaw, Daughter, _),
    parent(Parent, Daughter),
    male(SonInLaw).

% 29. Является ли человек невесткой
daughter_in_law(DaughterInLaw, Parent) :-
    married(Son, DaughterInLaw, _),
    parent(Parent, Son),
    female(DaughterInLaw).

% 30. Является ли человек крёстным отцом
godfather(Godfather, Godchild) :-
    male(Godfather),
    \+ parent(Godfather, Godchild),
    close_relative(Godfather, Godchild).

% 31. Является ли человек крёстной матерью
godmother(Godmother, Godchild) :-
    female(Godmother),
    \+ parent(Godmother, Godchild),
    close_relative(Godmother, Godchild).

% 32. Являются ли два человека близкими родственниками
close_relative(Person1, Person2) :-
    blood_relative(Person1, Person2);
    in_law(Person1, Person2).

% 33. Является ли человек дедушкой
grandfather(Grandfather, Person) :-
    grandparent(Grandfather, Person),
    male(Grandfather).

% 34. Является ли человек бабушкой
grandmother(Grandmother, Person) :-
    grandparent(Grandmother, Person),
    female(Grandmother).

% 35. Является ли человек внуком
grandson(Grandson, Grandparent) :-
    grandparent(Grandparent, Grandson),
    male(Grandson).

% 36. Является ли человек внучкой
granddaughter(Granddaughter, Grandparent) :-
    grandparent(Grandparent, Granddaughter),
    female(Granddaughter).