%% SOLUCIÓN Y TESTS AQUÍ

% Integrante 1: Mercedes.
% Integrante 2: Matías.
rol(rafa, detective).
rol(homero, civil).
rol(burns, civil).
rol(bart, mafia).
rol(tony, mafia).
rol(maggie, mafia).
rol(nick, medico).
rol(hibbert, medico).
rol(lisa, detective).


% Ejercicio 1: rondas

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

perdio(Jugador, Ronda):-
    ronda(Ronda, eliminado(Jugador)). % Ya va a ser inversible, pues son hechos.

perdio(Jugador, Ronda) :-
    ronda(Ronda, atacado(Jugador)),
    not(salvo(_, Jugador, Ronda)). 
    % not(salvadoEnLaRonda(Ronda, Jugador)). %%%%%%%%%%%%%%%%%%%%%%%%% descomentar y comentar línea anterior %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

salvo(Medico, Jugador, Ronda):-
    ronda(Ronda, salva(Medico, Jugador)).

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CORREGIDO (se puede descartar)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
salvadoEnLaRonda(Ronda, Jugador):-
    ronda(Ronda, salva(_, Jugador)).*/

% El concepto utilizado para resolver este requerimiento es el de functor, lo que nos permitirá a futuro aplicar soluciones polimórficas.

% c). Casos de prueba

:- begin_tests(perdedores).

% Consultas individuales:

test(una_persona_pierde_en_una_ronda_si_es_eliminada_en_esa_ronda, nondet):- perdio(nick, 1).

test(una_persona_pierde_en_una_ronda_si_lo_ataca_la_mafia_y_no_es_salvado_por_ningun_medico_en_esa_ronda, nondet):- perdio(homero, 4).

test(una_persona_no_pierde_en_una_ronda_si_lo_ataca_la_mafia_y_es_salvado_por_algun_medico_en_esa_ronda, fail):- perdio(lisa, 1).

test(una_persona_pierde_en_una_ronda_si_lo_eliminan_aunque_lo_salve_un_medico, nondet):- perdio(rafa, 2).

test(una_persona_que_nunca_fue_eliminada_ni_atacada_no_perdio_en_ninguna_ronda, fail):- perdio(maggie, _).

test(en_una_ronda_puede_perder_mas_de_una_persona, set(Jugador = [bart, lisa])):- perdio(Jugador, 5).

% Consulta existencial (prueba de inversibilidad):

test(perdio_es_completamente_inversible, set((Jugador, Ronda) = [(nick, 1) ,(rafa, 2), (hibbert, 3), (tony, 4), (homero, 4), (bart, 5), (lisa, 5), (burns, 6)])):- perdio(Jugador, Ronda).

:- end_tests(perdedores).



% Ejercicio 2: contrincantes y ganador.

% Integrante 1: Mercedes

% a).

contrincante(Jugador, Contrincante):- sonContrincantes(Jugador, Contrincante).
contrincante(Jugador, Contrincante):- sonContrincantes(Contrincante, Jugador).

sonContrincantes(Jugador, Contrincante):-
    rol(Jugador, mafia),
    rol(Contrincante, RolContrincante),
    RolContrincante \= mafia. 

% b).

gano(Jugador):-
    esJugador(Jugador),
    not(perdio(Jugador, _)), % No existe al menos una ronda en la que haya perdido (involución de la negación).
    % not(perdio(Jugador, _)) puede ser hecho con un forall pero es más sencillo por la involución. 
    forall(contrincante(Jugador, Contrincante), perdio(Contrincante, _)).

esJugador(Jugador):-
    rol(Jugador, _).

% c). Casos de prueba

:- begin_tests(contrincantes).

% Consultas individuales:

test(un_miembro_de_la_mafia_no_es_contrincante_de_otro_miembro_de_la_mafia, fail) :- contrincante(tony, maggie).

test(un_miembro_de_la_mafia_es_contrincante_de_un_jugador_que_no_es_miembro_de_la_mafia, nondet) :- contrincante(homero, bart).

% Consulta existencial (prueba de inversibilidad):

%falta probar inversibilidad -> muy largo 
%test(contrincantes_es_inversible, ) :- .
:- end_tests(contrincantes).

:-begin_tests(ganadores).

% Consultas individuales:

test(un_jugador_gana_cuando_no_pierde_ninguna_ronda_y_todos_sus_contrincantes_si, nondet) :- gano(maggie).

test(un_jugador_no_gana_cuando_pierde_al_menos_una_ronda, fail) :- gano(nick).

% rari: test(un_jugador_no_gana_cuando_no_pierde_ninguna_ronda_pero_sus_contrincantes_no_pierden, fail) :-gano().

% Consulta existencial (prueba de inversibilidad):

test(gano_es_inversible, set(Jugador = [maggie])) :- gano(Jugador).

end_tests(ganadores).


% Ejercicio 3: imbatibles.

% Integrante 2: Matías

% a).
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5CORREGIDO (se puede descartar)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imbatible(Medico):-
    medico(Medico),
    forall(rondaAnteriorOIgualEnLaQueFueEliminado(Ronda, Medico), fueImbatible(Medico, Ronda)).
*/
imbatible(Medico):-
    medico(Medico),
    forall(salvo(Medico, Jugador, _), fueAtacado(Jugador)).
    %forall(salvo(Medico, Jugador), fueAtacado(Jugador)). %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DESCOMENTAR Y COMENTAR LÍNEA ANTERIOR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imbatible(Detective):-
    detective(Detective),
    forall(mafioso(Jugador), investigo(Detective, Jugador, _)).

fueAtacado(Jugador):-
    ronda(_, atacado(Jugador)).

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CORREGIDO (se puede descartar)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
rondaAnteriorOIgualEnLaQueFueEliminado(Ronda, Medico):-
    ronda(RondaEliminado, eliminado(Medico)),
    ronda(Ronda, _),
    Ronda =< RondaEliminado.
    
fueImbatible(Medico, Ronda):-
    ronda(Ronda, _),
    forall(jugadorAtacadoNoSalvadoPorOtroMedico(Jugador, Medico, Ronda), salvo(Medico, Jugador, Ronda)).

jugadorAtacadoNoSalvadoPorOtroMedico(Jugador, Medico, Ronda):-
    ronda(Ronda, atacado(Jugador)),
    medico(OtroMedico),
    OtroMedico \= Medico, % No habrá problemas de inversibilidad, pues la variable Medico ya viene ligada y el predicado sólo se usa en fueImbatible/2.
    not(ronda(Ronda, salva(OtroMedico, Jugador))).
*/
medico(Jugador):-
    rol(Jugador, medico).

detective(Jugador):-
    rol(Jugador, detective).

mafioso(Jugador):-
    rol(Jugador, mafia).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VER SI USAR ESTE PREDICADO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
/*salvo(Medico, Jugador, Ronda):-
    ronda(Ronda, salva(Medico, Jugador)).*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Acá creo que no se podría no repetir la forma de generar, pues los individuos (functores) tienen distinta aridad y propósito (es decir, no es como el caso en el que un individuo participe en una acción) %%%%%%%%%%%%%%%%%%%%
/*salvo(Medico, Jugador):- DESCOMENTAR
    ronda(_, salva(Medico, Jugador)).*/

investigo(Detective, Jugador, Ronda):-
    ronda(Ronda, investiga(Detective, Jugador)).

/*
El concepto de inversibilidad está presente en ciertos predicados y en otros no (especialmente el concepto de predicado completamente inversible). Esto
se da por ejemplo, con los predicados imbatible/1 y jugadorAtacadoNoSalvadoPorOtroMedico/3 respectivamente. Para el caso de los predicados no 
completamente inversibles (como el último mencionado), muchas veces no es necesario que posean dicha característica, ya que como se explicó en la línea
184, es un predicado que se utiliza como condición de una regla en la que las variables ya están ligadas al "ingresar" al mismo. En cambio, el predicado
imbatible/1 sí es completamente inversible (obviamente que esperamos de él esta característica).

Para el caso del resto de las personas que no son imbatibles, se tiene en cuenta el principio de universo cerrado, tomando así como falso a todo aquello
que no se pueda inferir como verdadero a partir la base .de conocimientos Relacionando este concepto con el de inversibilidad, se puede observar que por
ejemplo no se podría saber cuáles son aquellas personas que no son imbatibles a través de la consulta not(imbatible(Jugador)). ya que la misma retornaría
false. debido a que el predicado not/1 no es inversible. De hecho, al no figurar en la base de conocimientos aquellas personas que no son imbatibles, por
el principio de universo cerrado, las mismas son infinitas (en realidad cualquier átomo o número por ejemplo que no sea un individuo perteneciente a
la base de conocimientos no será imbatible), salvo que se cree un predicado específico para ello acotando el universo de las personas y así poder obtener
aquellas que no son imbatibles. El mismo podría desarrollarse de la siguiente manera:

noImbatible(Jugador):-
    esJugador(Jugador),
    not(imbatible(Jugador)).
*/

% b). Casos de prueba

:-begin_tests(personas_imbatibles).

% Consultas individuales:

test(un_medico_que_siempre_salvo_a_alguien_que_estaba_siendo_atacado_por_la_mafia_es_imbatible, nondet) :- imbatible(hibbert).

test(un_medico_que_no_siempre_salvo_a_alguien_que_estaba_siendo_atacado_por_la_mafia_no_es_imbatible, fail) :- imbatible(nick).

test(un_detective_que_investigo_a_todas_las_personas_que_pertenecen_a_la_mafia_es_imbatible, nondet) :- imbatible(lisa).

test(un_detective_que_no_investigo_a_todas_las_personas_que_pertenecen_a_la_mafia_no_es_imbatible, fail) :- imbatible(rafa).

test(un_civil_nunca_es_imbatible, fail) :- imbatible(homero).

% Consulta existencial (prueba de inversibilidad):

test(quienes_son_imbatibles, set(Jugador = [hibbert, lisa])) :- imbatible(Jugador).

end_tests(personas_imbatibles).


% Ejercicio 4: más info.

% a).

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SE PUEDE ELIMINAR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Consideramos que no hay repetición de lógica, ya que los predicados que se utilizan como condición son distintos (perdio/2 y ronda/2).
sigueEnJuego(Ronda, Jugador):-
    perdio(Jugador, RondaEnLaQuePerdio),
    ronda(Ronda, _),
    Ronda =< RondaEnLaQuePerdio.

% Hay que agregar la posibilidad de que un jugador siga en juego si nunca perdió: que no pierda en una ronda no implica que no siga en juego en esa ronda (es lo que pasa con maggie).
sigueEnJuego(Ronda, Jugador):-
    ronda(Ronda, _),
    gano(Jugador).
*/

sigueEnJuego(Ronda, Jugador):-
    esJugador(Jugador),
    ronda(Ronda, _),
    forall(rondaAnteriorA(RondaAnterior, Ronda), not(perdio(Jugador, RondaAnterior))).

sigueEnJuego(Ronda, Jugador):- % Sin importar si perdió en dicha ronda...
    perdio(Jugador, Ronda).

rondaAnteriorA(RondaAnterior, Ronda):-
    ronda(RondaAnterior, _),
    ronda(Ronda, _),
    RondaAnterior < Ronda.

% d). Punto a

:-begin_tests(siguen_en_juego).

% Consultas individuales:

test(una_persona_sigue_en_juego_en_una_ronda_por_mas_que_luego_pierda_en_dicha_ronda, nondet) :- sigueEnJuego(2, rafa).

test(una_persona_no_sigue_en_juego_en_una_ronda_si_perdio_en_una_ronda_anterior_a_la_misma, fail) :- sigueEnJuego(4, nick).

test(todas_las_personas_que_llegan_a_la_ultima_ronda_son_aquellas_que_no_perdieron_en_una_ronda_anterior_o_ganan_el_juego, set(Jugador = [maggie, burns])) :- sigueEnJuego(6, Jugador).

test(todas_las_personas_siguen_en_juego_en_la_primera_ronda, set(Jugador = [homero, burns, bart, tony, maggie, nick, hibbert, lisa, rafa])) :- sigueEnJuego(1, Jugador).

% Consulta existencial (prueba de inversibilidad):

test(sigue_en_juego_es_completamente_inversible, set((Ronda, Jugador) = [(1, maggie), (1, lisa), (1, bart), (1, homero), (1, hibbert), (1, burns), (1, rafa), (1, tony), (1, nick), (2, homero), (2, hibbert), (2, lisa), (2, bart), (2, burns), (2, rafa), (2, tony), (2, maggie), (3, homero), (3, burns), (3, hibbert), (3, lisa), (3, bart), (3, tony), (3, maggie), (4, homero), (4, tony), (4, burns), (4, bart), (4, maggie), (4, lisa), (5, bart), (5, burns), (5, lisa), (5, maggie), (6, maggie), (6, burns)])):- sigueEnJuego(Ronda, Jugador).

end_tests(siguen_en_juego).

% b). Mercedes

rondaInteresante(Ronda):-
    cantidadJugadoresEnJuegoEnRonda(Ronda, Cantidad),
    cantidadParaQueUnaRondaSeaInteresante(Cantidad).

cantidadJugadoresEnJuegoEnRonda(Ronda, Cantidad) :-
    % Hay que "limpiar" la lista para evitar repetidos -> falsos verdaderos
    ronda(Ronda, _),
    findall(Jugador, distinct(sigueEnJuego(Ronda, Jugador)), ListaJugadoresEnJuego),
    length(ListaJugadoresEnJuego, Cantidad).

cantidadParaQueUnaRondaSeaInteresante(Cantidad):-
    Cantidad > 7.

cantidadParaQueUnaRondaSeaInteresante(Cantidad):-
    cantidadDe(mafia, CantidadMafiosos),
    Cantidad =< CantidadMafiosos.

cantidadDe(Rol, Cantidad):- % No es necesario ligar la variable Rol (hacer a cantidadDe/2 inversible), por el mismo motivo explicitado en la línea 184.
    findall(Jugador, rol(Jugador, Rol), ListaJugadores),
    length(ListaJugadores, Cantidad).


% d). Punto b

:-begin_tests(rondas_interesantes).

test(una_ronda_con_mas_de_7_personas_en_juego_es_interesante, nondet):- rondaInteresante(1).

test(una_ronda_donde_hay_mas_integrantes_de_la_mafia_que_jugadores_es_interesante, nondet):- rondaInteresante(6).

test(una_ronda_con_7_jugadores_o_menos_no_es_interesante, fail):- rondaInteresante(3).

test(rondas_interesante_es_inversible, set(Ronda = [1,2,6])) :- rondaInteresante(Ronda).

end_tests(rondas_interesantes).

% c). Matías

vivioElPeligro(Jugador):-
    esCivilODetective(Jugador),
    jugoRonda(Jugador, Ronda),
    rondaPeligrosa(Ronda).

esCivilODetective(Jugador):-
    civil(Jugador).

esCivilODetective(Jugador):-
    detective(Jugador).

civil(Jugador):-
    rol(Jugador, civil).

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CORREGIDO (se puede descartar)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jugoRonda(Jugador, Ronda):-
    ronda(Ronda, atacado(Jugador)).

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, investiga(Jugador, _)).

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, investiga(_, Jugador)).

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, salva(Jugador, _)).

jugoRonda(Jugador, Ronda):-
ronda(Ronda, salva(_, Jugador)).

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, eliminado(Jugador)).
*/

%%%%%%%%%%%%%%%%%%%% VER SI NO SE PUEDEN USAR LOS PREDICADOS DEL PUNTO SIGUIENTE %%%%%%%%%%%%%%%%%%%%

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, Accion),
    involucrado(Jugador, Accion).

involucrado(Jugador, atacado(Jugador)).

involucrado(Jugador, investiga(Jugador, _)).

involucrado(Jugador, investiga(_, Jugador)).

involucrado(Jugador, salva(Jugador, _)).

involucrado(Jugador, salva(_, Jugador)).

involucrado(Jugador, eliminado(Jugador)).

rondaPeligrosa(Ronda):-
    cantidadJugadoresEnJuegoEnRonda(Ronda, CantidadDePersonasEnJuego),
    cantidadDe(civil, CantidadCiviles),
    CantidadDePersonasEnJuego is 3 * CantidadCiviles.

% d). Punto c

:-begin_tests(vivieron_el_peligro).

% Consutlas individuales:

test(un_civil_que_jugo_una_ronda_peligrosa_vivio_el_peligro, nondet):- vivioElPeligro(homero).

test(un_detective_que_jugo_una_ronda_peligrosa_vivio_el_peligro, nondet):- vivioElPeligro(lisa).

test(una_persona_que_no_es_civil_ni_detective_no_vivio_el_peligro, fail):- vivioElPeligro(tony).

test(un_detective_que_no_jugo_una_ronda_peligrosa_no_vivio_el_peligro, fail):- vivioElPeligro(rafa).

% Consulta existencial (prueba de inversibilidad):

test(quienes_vivieron_el_peligro, set(Jugador = [lisa, homero])):- vivioElPeligro(Jugador).

/*
Aclaración con respecto al último test:
La única ronda peligrosa es la ronda 4.
La cantidad de personas en juego en la ronda 6 es 2, y la cantidad de civiles iniciales es 2. Luego, 2 no es 3 * 2. Entonces la ronda 6 no es peligrosa.
La cantidad de personas en juego en la ronda 3 es 7, y la cantidad de civiles iniciales es 2. Luego, 7 no es 3 * 2. Entonces la ronda 3 no es peligrosa.
Ergo, como Burns juega sólo en las rondas 3 y 6, Burns no vivió el peligro.
*/

end_tests(vivieron_el_peligro).

% Ejercicio 5: estrategia.

% a).

jugadorProfesional(Jugador):-
    esJugador(Jugador),
    forall(contrincante(Jugador, Contrincante), responsable(Jugador, _, Contrincante)).

responsable(Jugador, atacado(Contrincante), Contrincante):-
    mafioso(Jugador).
    /*rol(Contrincante, Rol),
    Rol \= mafia.*/ % Consideramos que es innecesario, pues entre miembros de la mafia no se atacan (deducido a partir de la base de conocimientos). Lo mismo ocurrirá con salva(Jugador, Contrincante).
 
responsable(Jugador, investiga(Jugador, Contrincante), Contrincante):-
    ronda(_, investiga(Jugador, Contrincante)),
    %investigo(Jugador, Contrincante).
    imbatible(Jugador).

/* Funciona pero no sabemos por qué y si lo hacemos de otra forma, nos da rafa que no debería.
   Consideramos que imbatible/1 es similar a responsable/3, 
 */

responsable(Jugador, eliminado(Contrincante), Contrincante):-
    contrincante(Jugador, Contrincante).

/* responsable(Medico, salva(Medico, Jugador), Jugador):-
    ronda(_, salva(Medico, Jugador)). */

% Los de la mafia son siempre profesionales 

% b). 

afectado(Jugador, Accion, OtroJugador):-
    responsable(OtroJugador, Accion, Jugador).

estrategia(Estrategia):-
    findall(Accion, formaParteDeLaEstrategia(Accion), Estrategia).

formaParteDeLaEstrategia(Accion):-
    jugoRonda(Jugador, Ronda),
    afectado(Jugador, Accion, OtroJugador),
    jugoRonda(OtraRonda, OtroJugador), 
    OtraRonda is Ronda - 1.

formaParteDeLaEstrategia(Accion):-
    jugoRonda(1, Jugador),
    responsable(Jugador, Accion, OtroJugador),
    jugoRonda(2, OtroJugador).

formaParteDeLaEstrategia(Accion):-
    jugoRonda(6, Jugador),
    afectado(Jugador, Accion, OtroJugador),
    jugoRonda(5, OtroJugador).



























