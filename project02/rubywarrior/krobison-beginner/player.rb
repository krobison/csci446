
#Author: Kolten A. Robison

#------------Requirements-------------
#	For instance variables, I used 
#	the last stored health of the 
#	warrior, and whether or not he
#	has explored backward.
#
#	For class variables, I used
#	constants for different health
#	levels to monitor
#
#	For contstants, I used the
#	health monitoring variables
#
#	For hashing, I mapped the 
#	value of the backward direction
#	as a global variable, just
#	to experiment with ruby really
#
#	For arrays, I commonly capture
#	an array of 3 spaces with the
#	warrior.look command, and 
#	analyze the spaces
#
#	I defined many functions
#
#	And I commented throughout my code!
#
#

$h = Hash[2,:backward]

class Player
	def initialize()
		#Here I initialize the health monitoring values, as well as a boolean for whether the player has 'explored' backwards
		@@safeHealth = 15
		@@retreatHealth = 10
		@@criticalHealth = 5
		@health = 20
		@exploredBackward = false
		
	end
	
	def play_turn(warrior)
		#if there are stairs in front of me, and there is no captive on the stairs (like one of the levels) then automatically end the level
		if warrior.feel.stairs? && !warrior.feel.captive?
			warrior.walk!
			return
		end
	
		#handles checking for captives
		if checkCaptives(warrior,warrior.look)
			return
		#determines if the player should turn around
		elsif needPivot(warrior,warrior.look)
			return
		#a function to determine if the player should move down the hallway, even if he has not explored backwards yet
		elsif checkHallway(warrior,warrior.look,warrior.look($h[2]))
			return
		#checks for 'wizards' or other enemies that could be destroyed with a ranged weapon
		elsif checkWizards(warrior,warrior.look,warrior.look($h[2]))
			return
		#sees if an elemy is close to the player
		elsif enemyClose(warrior)
			return
		#explore backwards ;)
		elsif exploreBackward(warrior,warrior.look($h[2]))
			return
		#run from arrows if you are being attacked and it is a 'good' idea (e.g. you dont have a lot of health)
		elsif runFromArcher(warrior)
			return
		#heal if you can see enemies and you are low on health but not being attacked
		elsif relax(warrior)
			return
		end
		#by default, just walk forward!
		updateHealth(warrior)
		warrior.walk!
	end
	
	def checkCaptives(warrior,spaces)
		#rescue captives in front of me
		if warrior.feel.captive?
			warrior.rescue!
			updateHealth(warrior)
			return true
		end
		#rescue captives behind me!
		if warrior.feel($h[2]).captive?
			warrior.rescue!($h[2])
			updateHealth(warrior)
			return true
		end
		
		#if you can see a captive up ahead, go and get him!
		if spaces[0].empty? && spaces[1].captive?
			warrior.walk!
			updateHealth(warrior)
			return true
		end
		if spaces[0].empty? && spaces[1].empty? && spaces[2].captive?
			warrior.walk!
			updateHealth(warrior)
			return true
		end
		return false
	end
	
	def exploreBackward(warrior,spaces)
		if warrior.feel($h[2]).empty?
			if !@exploredBackward
				#IMPORTANT ON INCREASING SCORE
				#This ensures that I do not NEED to explore backwards if I can tell that there is nothing there
				if ((spaces[0].empty? && spaces[1].wall?)||(spaces[0].empty? && spaces[1].empty? && spaces[2].wall?))
					@exploredBackward = true
					return false
				end
				#walk backwards
				warrior.walk!($h[2]) 
				updateHealth(warrior)
				return true
			end
		else
			if !@exploredBackward
				@exploredBackward = true
			end
		end
		return false
	end
	
	def updateHealth(warrior)
		#update health
		@health = warrior.health
	end
	
	def enemyClose(warrior)
		#if there is an enemy and you are not almost dead, attack! otherwise, go backwards
		if warrior.feel.enemy?
			if warrior.health > @@criticalHealth
				warrior.attack!
				updateHealth(warrior)
				return true
			else
				warrior.walk!($h[2])
				updateHealth(warrior)
				return true
			end
		end
		return false
	end
	
	def runFromArcher(warrior)
		#if you are down to retreat health and being attacked, and you are not next to an enemy (which will be certain if this function even runs) then retreat!
		if warrior.health < @health && warrior.health < @@retreatHealth
			warrior.walk!($h[2])
			updateHealth(warrior)
			return true
		end
		return false
	end
	
	def relax(warrior)
		#if you have not lost health, and you CANNOT SEE ANY ENEMIES (increased score a lot) then heal
		if warrior.health >= @health
			if warrior.health <@@safeHealth && !(emptySpaces(warrior.look($h[2])) && emptySpaces(warrior.look))
				warrior.rest!
				updateHealth(warrior)
				return true
			end
		end
		return false
	end
	
	def needPivot(warrior,spaces)
		#turn around if you are against wall or you are about to be
		if warrior.feel.wall?
			warrior.pivot!
			updateHealth(warrior)
			return true
		end
		if spaces[0].empty? && spaces[1].wall?
			warrior.pivot!
			updateHealth(warrior)
			return true
		end
	end
	
	def checkWizards(warrior,spaces,spacesBack)
		#These conditionals check for formations of enemies to shoot at or avoid
		if spacesBack[2].enemy? && spaces[1].enemy?
			warrior.walk!
			updateHealth(warrior)
			return true
		end
		if spaces[1].enemy? && !spaces[0].captive?
			warrior.shoot!
			updateHealth(warrior)
			return true
		end
		if spaces[0].empty? && spaces[1].empty? && spaces[2].enemy?
			warrior.shoot!
			updateHealth(warrior)
			return true
		end
	end
	
	def checkHallway(warrior,spaces,spacesBack)
		#Walk forward in hallways
		if spaces[0].empty? && spaces[1].empty? && spaces[2].empty? && spacesBack[0].empty? && spacesBack[1].empty? && spacesBack[2].empty?
			warrior.walk!
			updateHealth(warrior)
			return true
		end
	end
	
	def emptySpaces(spaces)
		#if the spaces contain no enemies, return true
		if spaces[0].enemy? || spaces[1].enemy? || spaces[2].enemy?
			return false
		end
		return true
	end
	
end
