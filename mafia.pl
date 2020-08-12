% SOLUCIÓN Y TESTS AQUÍ

rol(homero, civil).
rol(burns, civil).
rol(bart, mafia).
rol(tony, mafia).
rol(maggie, mafia).
rol(nick, medico).
rol(hibbert, medico).
rol(lisa, detective).
rol(rafa, detective).


% RONDAS

% Ejercicio 1:

% a).

% ronda(nºRonda, Accion)

% Acciones:

/*
atacar(atacado).
investiga(investigador, investigado).
salva(medico, salvado).
eliminado(eliminado).
*/


ronda(1, atacado(lisa)).
ronda(1, salva(nick, nick)).
ronda(1, salva(hibbert, lisa)).
ronda(1, investiga(lisa, tony)).
ronda(1, investiga(rafa, lisa)).
ronda(1, eliminado(nick)).

ronda(2, atacado(rafa)).
ronda(2, salva(hibbert, rafa)).
ronda(2, investiga(lisa, bart)).
ronda(2, investiga(rafa, maggie)).
ronda(2, eliminado(rafa)).

ronda(3, atacado(lisa)).
ronda(3, salva(hibbert, lisa)).
ronda(3, investiga(lisa, burns)).
ronda(3, eliminado(hibbert)).

ronda(4, atacado(homero)).
ronda(4, investiga(lisa, homero)).
ronda(4, eliminado(tony)).

ronda(5, atacado(lisa)).
ronda(5, investiga(lisa, maggie)).
ronda(5, eliminado(bart)).

ronda(6, atacado(burns)).

% b).

perdio(Persona, Ronda):-
    ronda(Ronda, eliminado(Persona)). % Ya va a ser inversible, pues son hechos

perdio(Persona, Ronda) :-
    ronda(Ronda, atacado(Persona)), 
    not(salvadoEnLaRonda(Ronda, Persona)).

salvadoEnLaRonda(Ronda, Persona):- % VER SI DESPUES SE NECESITA SABER QUIEN SALVO A QUIEN
    ronda(Ronda, salva(_, Persona)).

% El concepto utilizado para resolver este requerimiento es el de functor, lo que nos permitirá a futuro aplicar soluciones polimórficas.

% c). Casos de prueba

:- begin_tests(perdedores).

% Consultas individuales:

test(una_persona_pierde_en_una_ronda_si_es_eliminada_en_esa_ronda, nondet):- perdio(nick, 1).

test(una_persona_pierde_en_una_ronda_si_lo_ataca_la_mafia_y_no_es_salvado_por_ningun_medico_en_esa_ronda, nondet):- perdio(homero, 4).

test(una_persona_no_pierde_en_una_ronda_si_lo_ataca_la_mafia_y_es_salvado_por_algun_medico_en_esa_ronda, fail):- perdio(lisa, 1).

test(una_persona_pierde_en_una_ronda_si_lo_eliminan_aunque_lo_salve_un_medico, nondet):- perdio(rafa, 2).

test(una_persona_que_nunca_fue_eliminada_ni_atacada_no_perdio_en_ninguna_ronda, fail):- perdio(maggie, _).

test(en_una_ronda_puede_perder_mas_de_una_persona, set(Persona = [bart, lisa])):- perdio(Persona, 5).

% Consulta existencial (prueba de inversibilidad):

test(perdio_es_completamente_inversible, set((Persona, Ronda) = [(nick, 1) ,(rafa, 2), (hibbert, 3), (tony, 4), (homero, 4), (bart, 5), (lisa, 5), (burns, 6)])):- perdio(Persona, Ronda).

:- end_tests(perdedores).

% GANADOR 

% Ejercicio 2. 

/* 
Conocer los contrincantes de una persona, o sea, los del otro bando. 
Si la persona pertenece a la mafia, los contrincantes son todos aquellos 
que no forman parte de la mafia; y viceversa. Esta relación debe ser simétrica.
 */
contrincante(Jugador, Contrincante):- sonContrincantes(Jugador, Contrincante).
contrincante(Jugador, Contrincante):- sonContrincantes(Contrincante, Jugador).

sonContrincantes(Jugador, Contrincante):-
    rol(Jugador, mafia),
    rol(Contrincante, RolContrincante),
    RolContrincante \= mafia. 

gano(Jugador):-
    esJugador(Jugador),
    not(perdio(Jugador, _)), %no existe al menos una ronda en la que haya perdido (involucion not)
    %not(perdio(Jugador, _)) puede ser hecho con un forall pero es mas sencillo x la involucion
    forall(contrincante(Jugador, Contrincante), perdio(Contrincante, _)).

esJugador(Jugador):-
    rol(Jugador, _).

/* 
 preguntar lo de la inversibilidad
*/

:- begin_tests(contrincantes).

test(un_miembro_de_la_mafia_no_es_contrincante_de_otro_miembro_de_la_mafia, fail) :- contrincante(tony, maggie).

test(un_miembro_de_la_mafia_es_contrincante_de_un_jugador_que_no_es_miembro_de_la_mafia, nondet) :- contrincante(homero, bart).

%falta probar inversibilidad -> muy largo 
%test(contrincantes_es_inversible, ) :- .
:- end_tests(contrincantes).

:-begin_tests(gano).

test(un_jugador_gana_cuando_no_pierde_ninguna_ronda_y_todos_sus_contrincantes_si, nondet) :- gano(maggie).

test(un_jugador_no_gana_cuando_pierde_al_menos_una_ronda, fail) :- gano(nick).

% rari: test(un_jugador_no_gana_cuando_no_pierde_ninguna_ronda_pero_sus_contrincantes_no_pierden, fail) :-gano().
test(gano_es_inversible, set(Jugador = [maggie])) :- gano(Jugador).

end_tests(gano).

/* 
:- begin_tests(nombre).

test(nombre, nondet) :- consulta.

test(nombre, fail) :- consulta.

test(nombre_es_totalmente_inversible, set((Jugador, Continente) = [(amarillo, americaDelNorte), (negro, oceania)])) :- ocupaContinente(Jugador, Continente).

:- end_tests(nombre).

 */





