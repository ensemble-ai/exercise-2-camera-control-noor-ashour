# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [Juan Alvarez] 
* *email:* [jfalvarez@ucdavis.edu]

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Functionality was implemented correctly and the code was well written. I liked that the student used a
function in the camera_controller_base class to set the cameras position and draw the cross. This makes
the code more reusable since a lot of other cameras also need to draw a cross. 

___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

___
#### Justification ##### 
The student did not implement the functionality correctly. 

The following objectives were not met:
"If the player is lagging behind and is touching the left edge of the box, the player should be pushed forward by that box edge."

Since this is the most important part of the assignment, as is what makes the autoscroll camera unique,
I have to give the student an unsatisfactory grade.

I think the likely culprit for this is that the student explicitly checks if the player is touching a corner. This is not necessary since if the student implemented the logic correclty the players position would be 
updated implicitly through correct collision detection.

I will give credit to the student for matching the autoscroll speed to the frame rate. 
This is a good optimization that will make the game run smoother on different devices 
and is generally considered good practice.
Also the student does export the required variables for the camera as specified in the project readme.


___
### Stage 3 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The student implemented the functionality correctly and the code was well written. 

The following objectives were met:
- The camera smoothly follows the player when the player is moving. 
- The camera will catch up to the player when the player is not moving at the catch up speed.

The following objectives were not met:
- the distance between the vessel and the camera should never exceed `leash_distance`.

The student did not implement the leash_distance functionality correctly. The camera should not be able to move past the leash_distance from the player.

In the student implementation, the camera will lerp to the player's position even if the player is outsideof the leash distance. This is not correct behavior as the camera should not move past the leash distance.

```gdscript
if distance_to_target < leash_distance:
			global_position = global_position.lerp(target_position, speed * delta)

```

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

___
#### Justification ##### 
The student had one major flaw in their implemetation. When the player boosts and then changes directions, the camera gets stuck and stops following the player. This bug violates the following objective that the 
camera should never exceed the leash distance from the player. 

The student did not implement the catchup_delay_duration functionality correctly.
The camera should only start lerping to the player's position after the player has stopped moving for catchup_delay_duration. When I changed the catchup_delay_duration to 5, the camera would not lerp to the player any more. This is likely because the student did not implement the timer correctly, as the timer is never 
reset. 

```gdscript
else: # player stopped moving
		if _timer == null:
			_timer = Timer.new()
			add_child(_timer)
			_timer.one_shot = true
			
			if !is_zero_approx(catchup_delay_duration):
				_timer.start(catchup_delay_duration)
		if _timer.is_stopped():
			global_position = global_position.lerp(target.global_position, catchup_speed * delta)

```


___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

___
#### Justification ##### 
There was a lot of major flaws in the students implementation. 

- The player can move outside of the cameras outer pushbox if moving fast enough (boosting)
- the camera moves when the player is moving within the inner-most area (i.e., inside the speedup zone's border and not between the speedup zone the outer pushbox)
- the camera also moves when the player moves away from the camera's outer pushbox in the opposite direction
- The player cannot reach any corner of the pushbox, the camera will always move faster than the player when moving diagonally.
- The logic for drawing the push zone border box is incorrect. You can change the size of the box in the UI but the box will always be drawn at the same size.

___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
There were a few lines of code that were too long. The student should try to keep the lines of code under 100 characters. there was quite a few instances of this happening.  
```gdscript
	var diff_btn_top_left_corner = (top_left - Vector2(diff_between_left_edges, diff_between_top_edges)).round()
	var diff_btn_bottom_right_corner = (bottom_right - Vector2(diff_between_right_edges, diff_between_bottom_edges)).round()
```
The student did not have 2 spaces between function definitions in the base class. This is a minor infraction but it is good practice to have 2 spaces between function definitions.
```gdscript
func draw_logic() -> void:
	pass

func draw_box(box_width : float, box_height : float) -> void:
    ...
    ...
    ...
```
There is more examples of this infractions in the student's code.

#### Style Guide Exemplars ####
There was one example where the student used a multi-line if statement. In this example
the student used a multi-line if statement to reduce the length of the line. 
This is a good practice as it makes the code more readable.
```gdscript
	if (
			diff_between_left_edges < 0 
			or diff_between_right_edges > 0
			or diff_between_bottom_edges > 0
			or diff_between_top_edges < 0
	):
		is_touching = true

```

There is actually a lot of example like this one so good job on that.


___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
I think that in the students implementation of the `target_focus.gd` scrupt. When the player stops moving
a new timer is created and added as a child to the camera. This may cause the scene tree to be cluttered with timers that are not being used. The student should have checked if the timer was already created before creating a new one. Ideally the timer should be created in the `_ready()` function and then started when the player stops moving.

```gdscript
else: # player stopped moving
		if _timer == null:
			_timer = Timer.new()
			add_child(_timer)
			_timer.one_shot = true
```

#### Best Practices Exemplars ####
I liked that the student made custom functions in the camera_controller_base class to set the cameras position and draw the cross. This makes the code more reusable since a lot of other cameras also need to draw a cross or boxes.

The student implementated the `draw_box` and `draw_cross` functions in the camera_controller_base class.
