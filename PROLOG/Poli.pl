%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Inteligencia Artificial           %
%            Proyecto 1:Polinomios            %
%                                             %
%  Salvador Alejandro Uribe Calva  -  188311  %
%  Bruno Vitte San Juan            -  179524  %
%  Paulina Garza Allende           -          %
%  Josué Miguel Méndez Sánchez	   -          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * Manejador de polinomios.
 * Operaciones: Suma, resta, multiplicación, derivada, evaluación,
 * y composición.
 * Los polinomios son representados como listas. Cada elemento de la
 * lista representa un coeficiente. El orden de los elementos es del
 * menor exponente, como cabeza, al del mayor exponente.
 *
 * Ej: [1,2,3,4] ---> 1+2x+3x^2+4x^3
 *
 * main.  -  Ejecución de las pruebas que están en el programa
 *           original de Java
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
add(List,[],List).

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
%minus([],[],[]).

/*
 * minus(i,i,o) - caso base 2: la segunda lista es más larga que
 *                             la primera lista.
*/
minus([],List,List).

/*
 * minus(i,i,o) - caso base 3: la primera lista es más
 *                             larga que la segunda lista.
*/
minus(List,[],List).

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
    elevate(Pol,Pol,Deg-1,_Acum,R).

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
    elevate(Pol,Acum,Deg-1,_L,R);
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

/*
 * hornerEval(i,i,o) - método auxiliar que recibe el polinomio para
 *                     invertirlo y poder aplicarle la regla de Horner
*/
hornerEval(List,Val,R):-
    reverse(List,ListInv),
    hornerEval(ListInv,Val,0,R).
/*
 * hornerEval(i,i,i,o) - método que evalúa un polinomio utilizando la
 *                       regla de Horner
*/

hornerEval([X|List1],Val,Acum,R):-
    Z is Acum*Val + X,
    hornerEval(List1,Val,Z,R).
/*
 * hornerEval(i,i,i,o) - definición auxiliar que nos permite terminar el
 *                       método
*/
hornerEval([],_,R,R).


% ---------------------------- DERIVADA ------------------------------

/*
 * derivar(i,o) - método auxiliar que toma un polinomio y recorre a la
 *                izquierda todos sus cocientes al quitar la cabeza,
 *                bajando así el grado.
*/
derivar([_|Lista],R):-
    derivar(Lista,1,R),
    !.
/*
 * derivar(i,i,o) - método que deriva un polinomio al recibir una lista
 *                  de cocientes y los multiplica por su respectivo
 *                  grado
*/
derivar([X|List],Exp,[Z|R]):-
    Z is X*Exp,
    Y is Exp+1,
    derivar(List,Y,R).

/*
 * derivar(i,i,o) - definición adicional que nos permite devolver el
 *                  polinomio derivado
 */
derivar(R,_,R).



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
    Pz = [0],
    P1 = [0,0,0,4],
    P2 = [0,0,3],
    P3 = [1],
    P4 = [0,2],
    %imprimiendo los polinomios
    write("zero(x) = "),imprime(Pz), %0
    nl,
    write("P1(X) = "), imprime(P1), %4x^3
    nl,
    write("P2(X) = "), imprime(P2), %3x^2
    nl,
    write("P3(X) = "), imprime(P3),  %1
    nl,
    write("P4(X) = "), imprime(P4), %2x
    nl,
    %sumando polinomios
    add(P1,P2,A),
    write("A(X) = P1(X) + P2(X) = "),imprime(A), %4x^3 + 3x^2
    nl,
    add(A,P3,B),
    write("B(X) = A(X) + P3(X) = "), imprime(B), %4x^3 + 3x^2 + 1
    nl,
    add(B,P4,P),
    write("P(X) = B(X) + P4(X) = "), imprime(P), %4x^3 + 3x^2 + 2x + 1
    nl,
    %definiendo polinomios
    Q1 = [0,0,3],
    Q2 = [5],
    %sumando polinomios
    add(Q1,Q2,Q),
    write("Q(X) = "), imprime(Q), %3x^2 + 5.
    nl,
    add(P,Q,R),
    write("P(X) + Q(X) = "),imprime(R), %4x^3 + 6x^2 + 2x + 6
    nl,
    %multiplicando polinomios
    times(P,Q,S),
    write("P(X) * Q(X) = "),imprime(S), %12x^5 + 9x^4 + 26x^3 + 18x^2 + 10x + 5
    nl,
    %composición de polinomios,
    comp(P,Q,T),
    write("P(Q(X)) = "),imprime(T), %108x^6 + 567x^4 + 996x^2 + 586
    nl,
    %Resta
    minus([0,0,0,0],P,Res),
    write("0 - P(X) = "),imprime(Res),
    nl,
    %Evaluar
    write("P(3) = "),hornerEval(P,3,H),
    write(H),
    nl,

    %Derivada

    derivar(P,Der),
    write("P'(X) = "),imprime(Der),
    nl,

    %Segunda Derivada
    derivar(Der,Der2),
    write("P''(X) = "),imprime(Der2),
    nl,
    !.


