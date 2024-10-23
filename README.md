# EcoSim
 Sandbox that simulates a custom ecosystem

## How It Works
1. The user is prompted to specify the amount of producers, herbivores, and carnivores
2. Entities are spawned and randomly scattered across the island
3. Producers produce food which herbivores feed off of, and carnivores hunt herbivores
4. If any given animal straves for a set amount of days, it dies
5. Consuming food within the time limit ensures survival, and even reproduction if fed well
6. Reproduction is basically duplication, but values of children are slightly modified to simulate mutation
7. Observe how the average values relevent to survival slowly evolve into an optimized state
- It seems that I haven't pushed the latest version yet, so these descriptions aren't 100% correct atm

## Controls
- Space to pause
- Right arrow key to toggle fast forward
- Esc to input the parameters again and restart

## Todo
- fix carnivore balancing issues to prevent all animals going extinct
- revamp file structure for a better dev environment
- optimize spawning and pathfinding
- revamp the visuals
