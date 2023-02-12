%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Inteligencia Artificial     %
%        Proyecto 1             %
%                               %
% 	**			 %
% 	**  			%
%	**			 %
% 	**			 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * Manejador de polinomios.
 * Operaciones: Suma, resta, multiplicación, derivada, evaluación,
 * y composición.
 * Los polinomios son representados como listas. Cada elemento de la
 * lista representa un coeficiente.
 * 
 * Las listas están organizadas del menor coeficiente al mayor coeficiente
 *
 * main. <----- Consulta sugerida.
*/

%------------------- SUMA -------------------------------
/*
 * add(i,i,o) - caso base 1: listas del mismo tamaño que se
 *                           terminaron de sumar.
*/
add([],[],[]).

/*
 * add(i,i,o) - caso base 2: la segunda lista es más larga que
 *                           la primera lista.
*/
add([],List,List).

/*
 * add(i,i,o) - caso base 3: la primera lista es más
 *                           larga que la segunda lista.
*/
add(Lista,[],Lista).

/*
 * add(i,i,o) - método que realiza la suma de polinomios.
*/
add([X|List1],[Y|List2],[Z|Resp]):-
    Z is X+Y,
    %llamada recursiva para continuar con la suma
    add(List1,List2,Resp).

%------------------- RESTA -------------------------------

/*
 * minus(i,i,o) - caso base 1: listas del mismo tamaño que se
 *                             terminaron de sumar.
*/
minus([],[],[]).

/*
 * minus(i,i,o) - caso base 2: la segunda lista es más larga que
 *                             la primera lista.
*/
minus([],List,List).

/*
 * minus(i,i,o) - caso base 3: la primera lista es más
 *                             larga que la segunda lista.
*/
minus(Lista,[],Lista).

/*
 * minus(i,i,o) - método que realiza la resta de polinomios.
*/
minus([X|List1],[Y|List2],[Z|Resp]):-
    Z is X-Y,
    %llamada recursiva para continuar con la resta
    minus(List1,List2,Resp).

%------------------- MULTIPLICACIÓN -------------------------------

/*
 * product(i,i,o) - caso base: se terminó de multiplicar los
 *                             elementos de la lista.
*/
product([],_M,[]).

/*
 * product(i,i,o) - método auxiliar que realiza la multiplicación
 *                  de un término por un polinomio.
*/
product([X|List1],M,[Y|Resp]):-
    %multiplicación
    Y is X*M,
    %llamada recursiva para seguir multiplicando
    product(List1,M,Resp).

/*
 * product(i,i,o) - caso base: se terminó de multiplicar los
 *                             elementos.
*/
times(_,[],[]).

/*
 * times(i,i,o) - método que recibe los dos polinomios a
 *                multiplicar y lleva la operación a cabo
 *                con ayuda de los métodos auxiliares.
*/
times(List1,[T|List2],Resp):-
    %llamada recursiva para recorrer lista
    times(List1,List2,Resp2),
    %para realizar el producto de un término por una lista
    product(List1,T,Resp3),
    %sumar los resultados obtenidos
    add(Resp3,[0|Resp2],Resp).

% --------------- COMPOSICIÓN DE FUNCIONES ----------------------------

/*
 * elevate(i,i,o) - método auxiliar que solo hace la llamada
 *                  al método elevate/4.
*/
elevate(Pol,Deg,R):-
    %llamada al método que realizará la operación
    elevate(Pol,Pol,Deg-1,Acum,R).

/*
 * elevate(i,i,i,i,o) - método auxiliar que toma un polinomio y
 *                      lo eleva a la potencia indicada.
*/
elevate(Pol,Pol2,Deg,Acum,R):-
    (Deg > 0 ->
    Pol2 = [X|Y],
    %para multiplicar el polinomio a elevar
    times(Pol,[X|Y],Acum),
    %llamada recursiva
    elevate(Pol,Acum,Deg-1,L,R);
    %regresar el valor del polinomio elevado
    R = Pol2).

/*
 * compose(i,i,o) - método auxiliar que hace la llamada
 *                  al método compose/5.
*/
comp(Pol1,Pol2,R):-
    %
    comp(Pol2,Pol1,0,[0],R).

/*
 * comp(i,i,i,i,o) - método que realiza la composición
 *                      de dos polinomios.
*/
comp(Pol1,[X|P2],Deg,Suma,R):-
    (Deg > 0 ->
    %para elevar el polinomio
    elevate(Pol1,Deg,Acum1),
    %para multiplicar el polinomio por una constante
    product(Acum1,X,Acum2),
    %para hacer la suma de resultados
    add(Suma,Acum2,Res);
    Res = [X]),
    %para continuar haciendo la composición, se interrumpe si ya no hay otro término
    (P2 \== [] ->
    comp(Pol1,P2,Deg+1,Res,R);
    R = Res).

% --------------- EVALUACIÓN DE FUNCIONES ----------------------------

%evaluate

% ---------------------------- DERIVADA ------------------------------

repite.
repite:-
    repite.

% derivative - llama a la funci[on recursiva empezando con un exponente
% 1 (ya que la derivada de una constante es 0)
% Si regresa falso, quiere decir que el polinomio solo contiene una
% constante
derivative(Pol,R):-
    Pol = [_|Lista],
    der(Lista,1,R,_,[]).

%asigna al resultado el valor de 0
derivative(_,R):-
    R is [0].

%se lleva a cabo el proceso de la derivada recursivamente
der(List,Deg,R,L,R2):-
    List = [X|Lista],
    Lista \== [],
    Y is X * Deg,
    der(Lista,Deg+1,L,R2),
    R = [Y|L],
    write("repite"),
    repite().

der(List,Deg,L,R):-
    List = [X|_],
    Y is X * Deg,
    append([Y],R,L).

% ---------------------------- IMPRIMIR ------------------------------

/*
 * imprime(i) -  método que recibe una lista, calcula el grado del
 *               polinomio a imprimir y llama a un método auxiliar
 *               para imprimir el primer término del polinomio.
*/
imprime(List):-
    %para obtener el grado del polinomio
    proper_length(List,X),
    Deg is X-1,
    %invertir la lista para imprimir el polinomio en orden
    reverse(List,Y),
    %llamada a método para imprimir primer término
    imprime(Y,Deg,1).

/*
 * imprime(i,i,i) - método auxilia que recibe una lista que representa
 *                  a un polinomio y el grado de este e imprime el
 *                  primer término del polinomio para después llamar a
 *                  un método que continúe imprimiendo el polinomio.
*/
imprime([X|List],Degree,_):-
    %verificar si es grado 0
    (Degree = 0 ->
       write(X);
    %verificar si es grado 1
       (Degree = 1 ->
          write(X),
          write("x");
       %else - imprimir normal
          write(X),
          write("x^"),
          write(Degree)
        )%fin if else
    ),%fin if else
    %ajustar grado
    NewDeg is Degree-1,
    %llamada para imprimir método
    imprime(List,NewDeg).

/*
 * imprime(i) -  caso base: la lista está vacía.
*/
imprime([],_).

/*
 * imprime(i,i) -  método  que imprime una lista en forma de polinomio.
 */
imprime([X|List],Degree):-
    %caso en el que el grado sea 0
    (Degree = 0, X \= 0 ->
       %verificar si es positivo o negativo
       (X > 0 ->
          write(" + "),
          write(X);
       %else (es negativo)
          write(" - "),
          Temp is -1*X,
          write(Temp));
    %else - caso en el que el grado sea 1
    (Degree = 1, X \= 0 ->
       %verificar si es positivo o negativo
       (X > 0 ->
          write(" + "),
          write(X),
          write("x");
       %else
          write(" - "),
          Temp is -1*X,
          write(Temp),
          write(X),
          write("x")
       )%cierre if else
    );
    %else (si no es grado 0 / 1)
    (X > 0, X \= 0 ->
       write(" + "),
       write(X),
       write("x^"),
       write(Degree);
    %else (es negativo)
       (X \= 0 ->
          write(" - "),
          Temp is -1*X,
          write(Temp),
          write("x^"),
          write(Degree);
       %else (como el coeficiente es 0, no se debe imprimir)
          write("")
       )% fin del if
     )%fin if else
    ),
    %disminuir el grado
    NewDeg is Degree-1,
    imprime(List,NewDeg).

% -------------------------------- MAIN ------------------------------

main:-
    %definiendo polinomios para realizar operaciones
    P1 = [0,0,0,4],
    P2 = [0,0,3],
    P3 = [1],
    P4 = [0,2],
    %imprimiendo los polinomios
    imprime(P1), %4x^3
    nl,
    imprime(P2), %3x^2
    nl,
    imprime(P3),  %1
    nl,
    imprime(P4), %2x
    %sumando polinomios
    add(P1,P2,A),
    imprime(A), %4x^3 + 3x^2
    nl,
    add(A,P3,B),
    imprime(B), %4x^3 + 3x^2 + 1
    nl,
    add(B,P4,P),
    imprime(P), %4x^3 + 3x^2 + 2x + 1
    nl,
    %definiendo polinomios
    Q1 = [0,0,3],
    Q2 = [5],
    %sumando polinomios
    add(Q1,Q2,Q),
    imprime(Q), %3x^2 + 5.
    nl,
    add(P,Q,R),
    imprime(R), %4x^3 + 6x^2 + 2x + 6
    nl,
    %multiplicando polinomios
    times(P,Q,S),
    imprime(S), %12x^5 + 9x^4 + 26x^3 + 18x^2 + 10x + 5
    nl,
    %composición de polinomios,
    comp(P,Q,T),
    imprime(T), %108x^6 + 567x^4 + 996x^2 + 586
    nl.






