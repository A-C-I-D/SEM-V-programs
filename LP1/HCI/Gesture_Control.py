import cv2
import mediapipe as mp
import numpy as np
import random
import time

#pip install mediapipe opencv-python numpy


mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.5,
)

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
FPS = 30 
BLOCK_SIZE = 20
MOVE_INTERVAL = 0.15 

BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
RED = (0, 0, 255)
WHITE = (255, 255, 255)
BLUE = (255, 0, 0)

class SnakeGame:
    def __init__(self):
        self.snake = [(SCREEN_WIDTH // 2 // BLOCK_SIZE * BLOCK_SIZE, SCREEN_HEIGHT // 2 // BLOCK_SIZE * BLOCK_SIZE)]  
        self.dir_vec = (BLOCK_SIZE, 0) 
        self.food = self.generate_food()
        self.score = 0
        self.game_over = False
        self.time_since_last_move = 0.0
        self.move_interval = MOVE_INTERVAL

    def generate_food(self):
        while True:
            x = random.randint(0, (SCREEN_WIDTH - BLOCK_SIZE) // BLOCK_SIZE) * BLOCK_SIZE
            y = random.randint(0, (SCREEN_HEIGHT - BLOCK_SIZE) // BLOCK_SIZE) * BLOCK_SIZE
            if (x, y) not in self.snake:
                return (x, y)

    def update(self, fingertip_pos, dt):
        if self.game_over:
            return

        if fingertip_pos:
            head_x, head_y = self.snake[0]
            rel_x = fingertip_pos[0] - head_x
            rel_y = fingertip_pos[1] - head_y
            dist = abs(rel_x) + abs(rel_y)
            if dist > BLOCK_SIZE / 2: 
                if abs(rel_x) > abs(rel_y):
                    proposed_dir = (BLOCK_SIZE, 0) if rel_x > 0 else (-BLOCK_SIZE, 0)
                else:
                    proposed_dir = (0, BLOCK_SIZE) if rel_y > 0 else (0, -BLOCK_SIZE)

                opposite_dir = (-self.dir_vec[0], -self.dir_vec[1])
                if proposed_dir != opposite_dir:
                    self.dir_vec = proposed_dir

        self.time_since_last_move += dt
        if self.time_since_last_move >= self.move_interval:
            head_x, head_y = self.snake[0]
            new_head = (head_x + self.dir_vec[0], head_y + self.dir_vec[1])

            if (new_head[0] < 0 or new_head[0] + BLOCK_SIZE > SCREEN_WIDTH or
                new_head[1] < 0 or new_head[1] + BLOCK_SIZE > SCREEN_HEIGHT):
                self.game_over = True
                self.time_since_last_move = 0
                return

            if new_head in self.snake:
                self.game_over = True
                self.time_since_last_move = 0
                return

            self.snake.insert(0, new_head)

            if new_head == self.food:
                self.score += 1
                self.food = self.generate_food()
                print(f"Yum! Score: {self.score}, Length: {len(self.snake)}") 
            else:
                self.snake.pop()  

            self.time_since_last_move = 0

    def draw(self, frame):
        for i, segment in enumerate(self.snake):
            color = GREEN if i == 0 else (0, 200, 0)
            cv2.rectangle(frame, (segment[0], segment[1]),
                          (segment[0] + BLOCK_SIZE, segment[1] + BLOCK_SIZE), color, -1)

        cv2.rectangle(frame, (self.food[0], self.food[1]),
                      (self.food[0] + BLOCK_SIZE, self.food[1] + BLOCK_SIZE), RED, -1)

        cv2.putText(frame, f"Score: {self.score}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, WHITE, 2)
        cv2.putText(frame, f"Length: {len(self.snake)}", (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, WHITE, 2)
        if self.game_over:
            cv2.putText(frame, "Game Over! Press 'r' to restart", (SCREEN_WIDTH//2 - 150, SCREEN_HEIGHT//2),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, WHITE, 2)

game = SnakeGame()
font = cv2.FONT_HERSHEY_SIMPLEX

cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, SCREEN_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, SCREEN_HEIGHT)

prev_time = time.time()
running = True

while running:
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)  
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    current_time = time.time()
    dt = current_time - prev_time
    prev_time = current_time
    results = hands.process(rgb_frame)

    fingertip_pos = None
    if results.multi_hand_landmarks:
        for hand_landmarks in results.multi_hand_landmarks:
            mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

            h, w, _ = frame.shape
            index_tip = hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP]
            fingertip_pos = (int(index_tip.x * w), int(index_tip.y * h))

            if fingertip_pos:
                cv2.circle(frame, fingertip_pos, 5, BLUE, -1)

    game.update(fingertip_pos, dt)
    game.draw(frame)

    cv2.putText(frame, "Guide snake H/V with index fingertip (keep ahead, no U-turns!)", (10, SCREEN_HEIGHT - 20),
                font, 0.5, WHITE, 1)
    cv2.putText(frame, "Press 'q' to quit", (SCREEN_WIDTH - 100, 30), font, 0.5, WHITE, 1)

    cv2.imshow('Gesture Snake Game', frame)

    key = cv2.waitKey(1000 // FPS) & 0xFF
    if key == ord('q'):
        running = False
    elif key == ord('r') and game.game_over:
        game = SnakeGame() 

cap.release()
cv2.destroyAllWindows()

print(f"Final Score: {game.score}, Length: {len(game.snake)}")
print("Thanks for playing!")