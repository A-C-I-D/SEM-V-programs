import cv2
import mediapipe as mp
import pydirectinput

# --- Initialization ---
# Initialize video capture from the webcam
cap = cv2.VideoCapture(0)
cap.set(3, 1280)  # Set width
cap.set(4, 720)   # Set height

# Initialize Mediapipe Hands
mp_hands = mp.solutions.hands
# Set up the Hands model:
# max_num_hands=1 to detect only one hand for simplicity
# min_detection_confidence=0.7 for better accuracy
hands = mp_hands.Hands(max_num_hands=1, min_detection_confidence=0.7)
mp_draw = mp.solutions.drawing_utils

print("Hand Controller Started. Show your left or right hand to the camera.")
print("Press 'q' to quit.")

# --- Main Loop ---
while True:
    # 1. Read a frame from the webcam
    success, img = cap.read()
    if not success:
        break

    # Flip the image horizontally for a natural mirror-like view
    img = cv2.flip(img, 1)
    
    # Convert the image from BGR (OpenCV's default) to RGB
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # 2. Process the image to find hands
    results = hands.process(img_rgb)
    
    action = "None" # Default action

    # 3. Check if a hand was detected
    if results.multi_hand_landmarks:
        # Get the first detected hand
        hand_landmarks = results.multi_hand_landmarks[0]
        hand_label = results.multi_handedness[0].classification[0].label

        # Draw the landmarks on the image for visualization
        mp_draw.draw_landmarks(img, hand_landmarks, mp_hands.HAND_CONNECTIONS)

        # 4. Interpret the gesture and send keyboard input
        if hand_label == "Right":
            action = "Move Left (A)"
            pydirectinput.press('a')
            # Release the other key to prevent conflicting inputs
            pydirectinput.keyUp('d')

        elif hand_label == "Left":
            action = "Move Right (D)"
            pydirectinput.press('d')
            # Release the other key
            pydirectinput.keyUp('a')

    else:
        # If no hand is detected, release all keys
        action = "No hand detected"
        pydirectinput.keyUp('a')
        pydirectinput.keyUp('d')
    
    # --- Display Information ---
    # Display the current action on the screen
    cv2.putText(img, f"Action: {action}", (20, 50), cv2.FONT_HERSHEY_COMPLEX, 
                1, (255, 0, 0), 2)

    # Show the webcam feed in a window
    cv2.imshow("Hand Gesture Controller", img)

    # Exit the loop if the 'q' key is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# --- Cleanup ---
print("Exiting controller...")
cap.release()
cv2.destroyAllWindows()