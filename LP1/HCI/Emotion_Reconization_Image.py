import cv2
import numpy as np
from tensorflow.keras.models import load_model
import tkinter as tk
from tkinter import filedialog
from PIL import Image, ImageTk

model_path = 'F:\SEM-V-programs\LP1\HCI\FER_model.h5'
model = load_model(model_path)
emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral']
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

def process_image(image_path):
    img = cv2.imread(image_path)
    if img is None:
        return None, None
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)
    result_img = img.copy()
    predictions_list = []

    for (x, y, w, h) in faces[:1]:
        cv2.rectangle(result_img, (x, y), (x+w, y+h), (255, 0, 0), 2)
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
        cv2.putText(result_img, f"{top_emotion}: {top_prob:.1f}%", (x, y-10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
        bar_height = 20
        bar_width = 200
        start_y = y + h + 10
        for i, (emotion, prob) in enumerate(zip(emotions, probs)):
            color = (0, 255, 0) if i == top_idx else (128, 128, 128)
            end_x = int(x + (prob / 100) * bar_width)
            cv2.rectangle(result_img, (x, start_y + i*bar_height),
                          (end_x, start_y + (i+1)*bar_height), color, -1)
            cv2.putText(result_img, f"{emotion}: {prob:.1f}%",
                        (x + bar_width + 10, start_y + i*bar_height + 15),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        predictions_list.append((top_emotion, top_prob, list(zip(emotions, probs))))

    return result_img, predictions_list if predictions_list else None

def upload_image():
    file_path = filedialog.askopenfilename(
        filetypes=[("Image files", "*.jpg *.jpeg *.png *.bmp *.tiff")])
    if not file_path:
        return
    result_img, predictions = process_image(file_path)
    if result_img is None:
        status_label.config(text="Error: Image not loaded.")
        return
    result_img_rgb = cv2.cvtColor(result_img, cv2.COLOR_BGR2RGB)
    pil_img = Image.fromarray(result_img_rgb)
    pil_img.thumbnail((600, 600))
    img_tk = ImageTk.PhotoImage(pil_img)
    image_label.config(image=img_tk)
    image_label.image = img_tk
    if predictions:
        pred_text = f"Top: {predictions[0][0]} ({predictions[0][1]:.1f}%)\n"
        for emotion, prob in predictions[0][2]:
            pred_text += f"{emotion}: {prob:.1f}%\n"
        result_text.config(text=pred_text.strip())
    else:
        result_text.config(text="No face detected.")
    status_label.config(text="Processing complete.")

root = tk.Tk()
root.title("Emotion Recognition - Image Upload")
root.geometry("700x800")

tk.Button(root, text="Upload Image", command=upload_image, font=("Arial", 12)).pack(pady=10)
image_label = tk.Label(root)
image_label.pack(pady=10)
result_text = tk.Label(root, text="", font=("Arial", 10), justify="left", fg="blue")
result_text.pack(pady=5)
status_label = tk.Label(root, text="Ready. Upload an image to start.", fg="green")
status_label.pack(pady=5)

root.mainloop()
print("Model loaded successfully")