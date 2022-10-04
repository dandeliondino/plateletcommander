// EXTERNAL update_journal()

-> gameloop


== gameloop ==
-> DONE


== damaged_endothelium ==
= tooltip
Damaged Endothelium
-> DONE

= more_info_title
Endothelium
-> DONE

= more_info
[b]Endothelial cells[/b] line the inner walls of blood vessels.

When they are damaged, they put out emergency SOS signals to bring platelets to their aid, and secrete proteins to activate them when they arrive.
-> DONE


== rbc ==
= tooltip
Red Blood Cell
-> DONE

= more_info_title
Red Blood Cells
-> DONE

= more_info
[b]Red Blood Cells[/b] traverse blood vessels to carry oxygen throughout the body. Try not to lose too many of them!

They also assist (involuntarily) in forming blood clots. See if you can capture one.
-> DONE



== resting_platelet ==
= tooltip
Platelet
-> DONE

= more_info_title
Platelet
-> DONE

= more_info
-> platelet.more_info


== activation_potion ==
= tooltip
Activation Potion
-> DONE

= more_info_title
Activation Potion
-> DONE

= more_info
A heady mix of the many compounds that convince platelets to activate.

Use: Apply to a platelet to put it to work.
-> DONE


== fibrin_potion ==
= tooltip
Elixir of Thrombin
-> DONE

= more_info_title
Elixir of Thrombin
-> DONE

= more_info
[b]Thrombin[/b] pulls proteins from thin air (or, rather, blood) and weaves them into sturdy ropes. These [b]fibrin[/b] ropes are guaranteed to keep your platelet plug safe in all but the highest pressure arteries.

Use: Sprinkle some thrombin on one of a platelet's connecting arms and watch it do its magic!
-> DONE


== xlink_potion ==
= tooltip
Factor XIII
-> DONE

= more_info_title
Factor XIII
-> DONE

= more_info
When nothing else will do the trick, [b]Factor XIII[/b] is the factor you need to keep your blood clot where you want it.

Use: Add Factor XIII to fibrin ropes to strengthen them.
-> DONE



== megakaryocyte ==
= tooltip
Megakaryocyte
-> DONE

= more_info_title
Megakaryocyte
-> DONE

= more_info
[b]Megakaryocytes[/b] are large calls that live in the bone marrow and spend their days growing platelets. They have tentacles that stretch into the bloodstream. From these tentacles, platelets mature and bud off.

In humans, approximately 10 million platelets are created [b]every 10 seconds[/b].

In this game, the megakaryocyte buds one new platelet [b]every 10 seconds[/b]. You can retrieve it by dragging it the blood vessel at the location you want it.
-> DONE





== budding_platelet ==
= tooltip
Budding Platelet: Check back later
-> DONE

= more_info_title
Platelet
-> DONE

= more_info
-> platelet.more_info


== ready_platelet ==
= tooltip
Platelet: Drag it into the bloodstream
-> DONE

= more_info_title
Platelet
-> DONE

= more_info
-> platelet.more_info



== activated_platelet ==
= tooltip
Activated Platelet
-> DONE

= more_info_title
Platelet
-> DONE

= more_info
-> platelet.more_info


== platelet ==
= more_info
[b]Platelets[/b] are the emergency response workers of the blood stream. When the walls of a blood vessel are damaged, they are called to create an emergency clot.
-> DONE




== quest_data ==
-> DONE

= quest_status(ref quest_steps)
"started":{is_quest_started(quest_steps)},
"completed":{is_quest_completed(quest_steps)},
-> DONE

= quest_step_status(ref quest_steps, step)
"started":{quest_steps ? (step-1)},
"completed":{quest_steps ? step},
-> DONE




// FUNCTIONS
== function complete_quest_step(ref quest_list, step) ==
~   quest_list += step 
~   update_journal()
~   return


== function is_quest_completed(ref quest_list) ==
// check if last step is completed
~    return quest_list ? LIST_MAX(LIST_ALL(quest_list))

== function is_step_completed(ref quest_list, step) ==
~   return quest_list ? step 

== function is_current_step(ref quest_list, step) ==
~  return LIST_VALUE(LIST_MAX(quest_list)) + 1 == LIST_VALUE(step)

== function is_quest_ready_to_start(ref quest_list) ==
~ return LIST_VALUE(LIST_MAX(quest_list)) == 1

== function is_quest_started(ref quest_list) ==
// 1 is the "ready to start" step
~   return LIST_VALUE(LIST_MAX(quest_list)) > 1


// EXTERNAL FUNCTIONS
== function update_journal() ==
~ return