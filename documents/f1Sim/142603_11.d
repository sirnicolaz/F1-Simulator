format 67

subject 128011 ""
  xyzwh 138 52 2000 260 270
note 128139 "Info concorrente"
  xyzwh 203 2 2005 106 35
usecasecanvas 128267 usecase_ref 147851 // Aggiorna tabella
  xyzwh 202 76 3005 123 37 label_xy 220 84
end
classcanvas 128395 class_ref 128011 // Concorrente
  class_drawing_mode default show_context_mode default show_stereotype_properties default
  xyz 49 65 2005
end
note 128651 "Per ogni tratto: 
- N° tratto
- Tempo
- Benzina
- Gomme
- Giro
- Settore"
  xyzwh 415 54 2000 112 120
note 128779 "Statistiche calcolabili:
- Miglior giro (conc)
- Miglior tempo per ogni settore (conc)
- Stato auto
- Consumo medio di benzina
- Media velocità

Tutte le statistiche sul singolo concorrente"
  xyzwh 549 52 2000 231 131
usecasecanvas 128907 usecase_ref 147979 // Ottieni informazione N
  xyzwh 205 270 3005 129 40 label_xy 218 282
end
usecasecanvas 129675 usecase_ref 148107 // Ottieni informazione 1
  xyzwh 200 153 3005 132 39 label_xy 215 162
end
usecasecanvas 129803 usecase_ref 148235 // Ottieni informazione 2
  xyzwh 205 204 3005 128 39 label_xy 216 216
end
classcanvas 130059 class_ref 136331 // Box
  class_drawing_mode default show_context_mode default show_stereotype_properties default
  xyz 40 210 2000
end
classcanvas 130571 class_ref 136459 // MonitorPubblico
  class_drawing_mode default show_context_mode default show_stereotype_properties default
  xyz 454 201 2000
end
line 128523 --->
  from ref 128395 z 3006 to ref 128267
line 130187 --->
  from ref 130059 z 3006 to ref 129675
line 130315 --->
  from ref 130059 z 3006 to ref 129803
line 130443 --->
  from ref 130059 z 3006 to ref 128907
line 130699 --->
  from ref 130571 z 3006 to ref 129675
line 130827 --->
  from ref 130571 z 3006 to ref 129803
line 130955 --->
  from ref 130571 z 3006 to ref 128907
line 129931 -_-_
  from ref 129803 z 3006 to ref 128907
end
