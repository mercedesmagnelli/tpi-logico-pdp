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

salvo(Medico, Jugador, Ronda):-
    ronda(Ronda, salva(Medico, Jugador)).

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


% b)

gano(Jugador):-
    esJugador(Jugador),
    not(perdio(Jugador, _)), % No existe al menos una ronda en la que haya perdido (involución de la negación).
    % not(perdio(Jugador, _)) puede ser hecho con un forall pero es más sencillo por la involución. 
    forall(contrincante(Jugador, Contrincante), perdio(Contrincante, _)).

esJugador(Jugador):-
    rol(Jugador, _).


/* En este predicado gano/1 la inversibilidad puede relacionarse con el hecho de que el predicado esJugador/1 funciona 
como generador de la variable Jugador. Esto me va a permitir utilizar el predicado not/1 sin tener algún problema
con la inversibilidad, ya que el not/1 no es inversible. */

% c). Casos de prueba

:- begin_tests(contrincantes).

% Consultas individuales:

test(un_miembro_de_la_mafia_no_es_contrincante_de_otro_miembro_de_la_mafia, fail) :- contrincante(tony, maggie).

test(un_miembro_de_la_mafia_es_contrincante_de_un_jugador_que_no_es_miembro_de_la_mafia, nondet) :- contrincante(homero, bart).

% Consulta existencial (prueba de inversibilidad):

test(contrincante_es_completamente_inversible, set((Jugador, Contrincante) = [(bart, rafa), (bart, homero), (bart, burns), (bart, nick), (bart, hibbert), (bart, lisa), (tony, rafa), (tony, homero), (tony, burns), (tony, nick), (tony, hibbert), 
(tony, lisa), (maggie, rafa), (maggie, homero), (maggie, burns), (maggie, nick), (maggie, hibbert), (maggie, lisa), (rafa, bart), (homero, bart), (burns, bart),(nick, bart), (hibbert, bart), (lisa, bart), (rafa, tony), (homero, tony),
(burns, tony), (nick, tony), (hibbert, tony),(lisa, tony), (rafa, maggie), (homero, maggie), (burns, maggie), (nick, maggie), (hibbert, maggie), (lisa, maggie)])) :- contrincante(Jugador, Contrincante).


:- end_tests(contrincantes).

:-begin_tests(ganadores).

% Consultas individuales:

test(un_jugador_gana_cuando_no_pierde_ninguna_ronda_y_todos_sus_contrincantes_si, nondet) :- gano(maggie).

test(un_jugador_no_gana_cuando_pierde_al_menos_una_ronda, fail) :- gano(nick).

test(un_jugador_no_gana_cuando_no_pierde_ninguna_ronda_pero_sus_contrincantes_no_pierden, fail) :-gano(burns).

% Consulta existencial (prueba de inversibilidad):

test(gano_es_inversible, set(Jugador = [maggie])) :- gano(Jugador).

end_tests(ganadores).

% Ejercicio 3: imbatibles.

% Integrante 2: Matías

% a).

imbatible(Medico):-
    medico(Medico),
    forall(salvo(Medico, Jugador, _), fueAtacado(Jugador)).

imbatible(Detective):-
    detective(Detective),
    forall(mafioso(Jugador), investigo(Detective, Jugador, _)).

fueAtacado(Jugador):-
    ronda(_, atacado(Jugador)).

medico(Jugador):-
    rol(Jugador, medico).

detective(Jugador):-
    rol(Jugador, detective).

mafioso(Jugador):-
    rol(Jugador, mafia).

investigo(Detective, Jugador, Ronda):-
    ronda(Ronda, investiga(Detective, Jugador)).

/*
El concepto de inversibilidad está presente en ciertos predicados y en otros no (especialmente el concepto de predicado completamente inversible). Para
el caso de los predicados no completamente inversibles muchas veces no es necesario que posean dicha característica, ya que puede tratarse de un 
predicado que se utiliza como condición de una regla en la que las variables ya están ligadas al "ingresar" al mismo. Para el caso de los predicados
completamente inversibles, como lo es imbatible/1, obviamente esperamos de él esta característica.

¿Cómo se relaciona el principio de universo cerrado con la inversibilidad (no inversibilidad del predicado not/1 en este caso)?

Para el caso de los jugadores que NO son imbatibles, se tiene en cuenta el principio de universo cerrado, tomando así como falso a todo aquello que no
se pueda inferir como verdadero a partir la base de conocimientos. Relacionando este concepto con el de inversibilidad, se puede observar que por 
ejemplo no se podría saber cuáles son aquellos jugadores que NO son imbatibles a través de la consulta not(imbatible(Jugador)). ya que la misma
retornaría false. debido a que el predicado not/1 NO es inversible. De hecho, al no figurar en la base de conocimientos aquellos jugadores que NO son
imbatibles, por el principio de universo cerrado, los mismos son "infinitos" (en realidad cualquier átomo o número por ejemplo que no sea un individuo
perteneciente a la base de conocimientos NO será imbatible), salvo que se cree un predicado específico para ello ACOTANDO el universo de los jugadores y
así poder obtener aquellos que NO son imbatibles. El mismo podría desarrollarse de la siguiente manera:

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
    ronda(Ronda, _),
    findall(Jugador, distinct(sigueEnJuego(Ronda, Jugador)), ListaJugadoresEnJuego),
    length(ListaJugadoresEnJuego, Cantidad).

cantidadParaQueUnaRondaSeaInteresante(Cantidad):-
    Cantidad > 7.

cantidadParaQueUnaRondaSeaInteresante(Cantidad):-
    cantidadDe(mafia, CantidadMafiosos),
    Cantidad =< CantidadMafiosos.

cantidadDe(Rol, Cantidad):- % No es necesario ligar la variable Rol (hacer a cantidadDe/2 inversible).
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

jugoRonda(Jugador, Ronda):-
    ronda(Ronda, Accion),
    sigueEnJuego(Ronda, Jugador),    
    involucrado(Jugador, Accion).

involucrado(Jugador, Accion):-
    responsable(Jugador, Accion).

involucrado(Jugador, Accion):-
    afectaA(Jugador, Accion). 

responsable(Jugador, atacado(_)):-
    mafioso(Jugador).

responsable(Jugador, eliminado(Contrincante)):-
    contrincante(Jugador, Contrincante).

responsable(Jugador, investiga(Jugador, _)). 

responsable(Jugador, salva(Jugador, _)). 

afectaA(Jugador, eliminado(Jugador)). 

afectaA(Jugador, salva(_, Jugador)). 

afectaA(Jugador, investiga(_, Jugador)). 

afectaA(Jugador, atacado(Jugador)). 

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

test(quienes_vivieron_el_peligro, set(Jugador = [lisa, homero, burns])):- vivioElPeligro(Jugador).

end_tests(vivieron_el_peligro).

% Ejercicio 5: estrategia.

% a).

jugadorProfesional(Jugador):-
    esJugador(Jugador),
    forall(contrincante(Jugador, Contrincante), leHizoAlgo(Jugador, Contrincante)).

leHizoAlgo(Jugador, Contrincante):-
    ronda(Ronda, Accion),
    sigueEnJuego(Ronda, Jugador), % Va a estar relacionado con la accion siempre y cuando siga jugando 
    responsable(Jugador, Accion),
    afectaA(Contrincante, Accion).

% c). Casos de prueba para jugadorProfesional/1:

:-begin_tests(jugadores_profesionales).

% Consultas individuales:

test(un_jugador_que_le_hizo_algo_a_todos_sus_contrincantes_es_profesional, nondet) :- jugadorProfesional(lisa).

test(un_jugador_para_el_cual_no_todos_sus_contrincantes_no_se_vieron_afectados_por_sus_acciones_no_es_un_jugador_profesional, fail):- jugadorProfesional(bart).

% Consulta existencial (prueba de inversibilidad):

test(jugador_profesional_es_inversible, set(Jugador = [lisa, maggie])) :- jugadorProfesional(Jugador).

end_tests(jugadores_profesionales).

% b).

estrategia(Estrategia):-
    estrategiasPosibles(1, Estrategia),
    length(Estrategia, CantidadAccionesEstrategia),
    ultimaRonda(CantidadAccionesEstrategia).
   
estrategiasPosibles(Ronda, [Accion]):-
    ronda(Ronda, Accion).

estrategiasPosibles(Ronda, [PrimeraAccion, SegundaAccion|RestoDeLasAcciones]):-
    %esJugador(Jugador),
    ronda(Ronda, PrimeraAccion),
    afectaA(Jugador, PrimeraAccion),
    responsable(Jugador, SegundaAccion),
    ProximaRonda is Ronda + 1,
    estrategiasPosibles(ProximaRonda, [SegundaAccion|RestoDeLasAcciones]).

ultimaRonda(Ronda):-
    ronda(Ronda, _),
    forall(ronda(OtraRonda, _), Ronda >= OtraRonda).

% c). Casos de prueba para estrategia/1:

:-begin_tests(estrategias).

% Consultas individuales:

test(una_cadena_de_acciones_encadenadas_que_se_suceden_en_orden_y_que_no_termina_en_la_ultima_ronda_no_es_una_estrategia, fail) :- estrategia([atacado(lisa), investiga(lisa, bart)]).

test(una_cadena_de_acciones_encadenadas_que_se_suceden_en_orden_y_que_termina_en_la_ultima_ronda_es_una_estrategia, nondet) :- estrategia([investiga(rafa, lisa), investiga(lisa, bart), atacado(lisa), investiga(lisa, homero), eliminado(bart), atacado(burns)]).

test(una_cadena_de_acciones_encadenadas_que_no_se_suceden_en_orden_sin_importar_donde_terminan_no_es_estrategia, fail):-estrategia([investiga(rafa, lisa), atacado(lisa),eliminado(bart), investiga(lisa, homero), atacado(burns), investiga(lisa, bart)]).

test(una_serie_de_acciones_no_encadenadas_no_es_estrategia_sin_importar_donde_termine, fail) :- estrategia([salva(nick, nick), salva(hibbert, lisa)]).

% Consulta existencial (prueba de inversibilidad):

test(estrategia_es_inversible, set(Estrategia = [[atacado(lisa), investiga(lisa, bart), atacado(lisa), investiga(lisa, homero), eliminado(bart), atacado(burns)], 
[salva(hibbert, lisa), investiga(lisa, bart), atacado(lisa), investiga(lisa, homero), eliminado(bart), atacado(burns)],
[investiga(rafa, lisa), investiga(lisa, bart), atacado(lisa), investiga(lisa, homero), eliminado(bart), atacado(burns)]])):- estrategia(Estrategia).

end_tests(estrategias).

