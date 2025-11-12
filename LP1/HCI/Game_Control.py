import pygame
import random
import sys

pygame.init()

WIDTH = 800
HEIGHT = 600

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 100, 255)
YELLOW = (255, 255, 0)

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Catch the Falling Objects!")

clock = pygame.time.Clock()
FPS = 30

font = pygame.font.Font(None, 36)
small_font = pygame.font.Font(None, 24)

class Player:
    def __init__(self):
        self.width = 80
        self.height = 20
        self.x = WIDTH // 2 - self.width // 2
        self.y = HEIGHT - 50
        self.speed = 20
        self.color = BLUE
    
    def move_left(self):
        self.x -= self.speed
        if self.x < 0:
            self.x = 0
    
    def move_right(self):
        self.x += self.speed
        if self.x > WIDTH - self.width:
            self.x = WIDTH - self.width
    
    def draw(self):
        pygame.draw.rect(screen, self.color, (self.x, self.y, self.width, self.height))

class FallingObject:
    def __init__(self):
        self.width = 30
        self.height = 30
        self.x = random.randint(0, WIDTH - self.width)
        self.y = -self.height
        self.speed = random.randint(3, 7)
        self.color = random.choice([RED, GREEN, YELLOW])
    
    def fall(self):
        self.y += self.speed
    
    def draw(self):
        pygame.draw.circle(screen, self.color, (self.x + self.width // 2, self.y + self.height // 2), self.width // 2)
    
    def is_off_screen(self):
        return self.y > HEIGHT

player = Player()
objects = []
score = 0
lives = 3
spawn_timer = 0
game_over = False

running = True
while running:
    clock.tick(FPS)
    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_r and game_over:
                # Restart game
                player = Player()
                objects = []
                score = 0
                lives = 3
                game_over = False
    
    if not game_over:
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            player.move_left()
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            player.move_right()
        
        spawn_timer += 1
        if spawn_timer > 40:
            objects.append(FallingObject())
            spawn_timer = 0
    
        for obj in objects[:]:
            obj.fall()
    
            if (obj.y + obj.height >= player.y and 
                obj.x + obj.width > player.x and 
                obj.x < player.x + player.width):
                objects.remove(obj)
                score += 10
            
            elif obj.is_off_screen():
                objects.remove(obj)
                lives -= 1
                if lives <= 0:
                    game_over = True
    
    screen.fill(WHITE)
    
    if not game_over:
        player.draw()
        
        for obj in objects:
            obj.draw()
        
        score_text = font.render(f"Score: {score}", True, BLACK)
        lives_text = font.render(f"Lives: {lives}", True, BLACK)
        screen.blit(score_text, (10, 10))
        screen.blit(lives_text, (10, 50))
        
        # Draw instructions
        inst_text = small_font.render("Use Arrow Keys or A/D to move", True, BLACK)
        screen.blit(inst_text, (WIDTH - 300, 10))
    
    else:
        game_over_text = font.render("GAME OVER!", True, RED)
        final_score_text = font.render(f"Final Score: {score}", True, BLACK)
        restart_text = small_font.render("Press R to Restart", True, BLACK)
        
        screen.blit(game_over_text, (WIDTH // 2 - 100, HEIGHT // 2 - 50))
        screen.blit(final_score_text, (WIDTH // 2 - 120, HEIGHT // 2))
        screen.blit(restart_text, (WIDTH // 2 - 100, HEIGHT // 2 + 50))
    
    pygame.display.flip()

pygame.quit()
sys.exit()