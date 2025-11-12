import cv2
import numpy as np
from tensorflow.keras.models import load_model

model_path = 'FER_model.h5'
#url = 'https://raw.githubusercontent.com/SajalSinha/Facial-Emotion-Recognition/main/FER_model.h5'

model = load_model(model_path)

emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral']

face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

while True:
    ret, frame = cap.read()
    if not ret:
        break
    frame = cv2.flip(frame, 1)  

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces[:1]: 
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2)

        face_roi = gray[y:y+h, x:x+w]
        if face_roi.size == 0:
            continue
        face_roi = cv2.resize(face_roi, (48, 48)) 
        face_roi = face_roi.astype('float32') / 255.0
        face_roi = np.expand_dims(face_roi, axis=(0, -1))

        predictions = model.predict(face_roi, verbose=0)[0]
        probs = predictions * 100  

        top_idx = np.argmax(probs)
        top_emotion = emotions[top_idx]
        top_prob = probs[top_idx]

        cv2.putText(frame, f"{top_emotion}: {top_prob:.1f}%", (x, y-10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

        bar_height = 20
        bar_width = 200
        start_y = y + h + 10
        for i, (emotion, prob) in enumerate(zip(emotions, probs)):
            color = (0, 255, 0) if i == top_idx else (128, 128, 128)
            end_x = int(x + (prob / 100) * bar_width)
            cv2.rectangle(frame, (x, start_y + i*bar_height), 
                          (end_x, start_y + (i+1)*bar_height), color, -1)
            cv2.putText(frame, f"{emotion}: {prob:.1f}%", 
                        (x + bar_width + 10, start_y + i*bar_height + 15),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)

    cv2.putText(frame, "Press 'q' to quit", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)

    cv2.imshow('Live Emotion Recognition', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print("Model loaded successfully")