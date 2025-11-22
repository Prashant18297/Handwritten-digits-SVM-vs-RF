# 📘 Handwritten Digit Classification – SVM vs Random Forest

**Machine Learning Project | MNIST Dataset**

---

## 📌 1. Project Overview

This project evaluates and compares two classical machine learning models—**Support Vector Machine (SVM)** and **Random Forest (RF)**—for handwritten digit classification using the **MNIST dataset**.
The goal is to study the impact of preprocessing, analyze the classification performance of both models, and determine which algorithm is better suited for digit recognition under typical machine learning constraints.

---

## 🎯 2. Motivation

Digit recognition is a foundational step in many automation systems. Accurate handwritten digit classification improves efficiency in:

* Banking systems (cheque reading, form digitization)
* Postal services (automated sorting of handwritten addresses)
* Document processing and OCR systems
* Automated data entry pipelines

The MNIST dataset provides a benchmark platform to compare models and understand their suitability for real-world digit recognition tasks.

---

## 📂 3. Repository Structure

```
├── data/
│   └── README.md
│
├── src/
│   ├── data_loader.py
│   ├── preprocess.py
│   ├── train_svm.py
│   ├── train_rf.py
│   └── evaluate.py
│
├── notebooks/
│   ├── 01_EDA.ipynb
│   ├── 02_SVM_Model.ipynb
│   └── 03_RF_Model.ipynb
│
├── figures/
│   ├── class_distribution.png
│   ├── svm_confusion_matrix.png
│   ├── rf_confusion_matrix.png
│   └── sample_digits.png
│
├── reports/
│   └── MNIST_Final_Report.pdf
│
├── slides/
│   └── MNIST_Presentation.pptx
│
├── requirements.txt
├── run.sh
└── README.md
```

---

## 📊 4. Dataset Description

**Dataset:** MNIST – Handwritten Digit Database
**Source:** OpenML (554) / Yann LeCun
**Format:** Grayscale images, 28×28 pixels
**Total Samples:** 70,000

* 60,000 training
* 10,000 testing

**Classes:** Digits from **0 to 9** (10 classes)
**Distribution:** Balanced across all digits
**Feature Extraction:** Each 28×28 image is flattened into a **784-feature vector**

---

## 🔍 5. Exploratory Data Analysis (EDA)

Key findings from dataset inspection:

* **Balanced class distribution**, enabling unbiased model training
* **Distinct pixel intensity patterns** for each digit
* **Natural handwriting variations** introduce realistic classification difficulty
* **Clean and noise-free data**, ideal for controlled ML experiments
* Visual sample inspection confirms diverse writing styles and shape distortions

EDA included visualizations such as:

* Class distribution bar chart
* Sample digit grids
* Pixel intensity histograms
* Confusion matrices for both models

---

## ⚙️ 6. Preprocessing Pipeline

1. **Load MNIST** via OpenML
2. **Flatten** 28×28 images into 784-dimensional vectors
3. Convert pixel intensity to `float32`
4. **Normalize** intensity values to the range **0–1** using MinMaxScaler
5. Shuffle dataset for randomness
6. Use default MNIST train/test split
7. Scale data specifically for SVM (mandatory due to kernel sensitivity)
8. Use same scaled data for RF for consistency

This preprocessing ensures both models receive standardized input vectors.

---

## 🤖 7. Models Implemented

### **Support Vector Machine (SVM)**

* Kernel: **RBF**
* Hyperparameters tuned:

  * `C` in [1, 5, 10]
  * `gamma` in [0.001, 0.01]
* Strong performance on high-dimensional data
* Sensitive to feature scaling
* More computationally expensive

### **Random Forest (RF)**

* 200 decision trees
* Max depth: 15–40
* Bootstrap sampling enabled
* Robust to noise and overfitting
* Faster training time
* Works well without heavy preprocessing

---

## 📈 8. Results & Discussion

Both models achieved high accuracy, demonstrating MNIST’s suitability for classical ML algorithms.

### **Performance Summary**

| Model             | Accuracy | Training Time | Key Notes                                   |
| ----------------- | -------- | ------------- | ------------------------------------------- |
| **SVM (RBF)**     | ~96-97%   | Slower        | Best accuracy, strong at complex boundaries |
| **Random Forest** | ~96–98%  | Faster        | More robust, simpler, faster to train       |

### **Insights**

* SVM excelled in capturing fine pixel-level differences
* RF is more scalable and less sensitive to hyperparameters
* RF misclassifies visually similar digits more often (3↔5, 4↔9)

### **Conclusion**

* **Random Forest outperformed SVM overall in this experiment**, considering the combination of accuracy and training speed
* The better model depends on:

  * Dataset size
  * Accuracy requirements
  * Execution time constraints
  * Infrastructure limitations

---

## 🧪 9. Reproducibility

To reproduce the project:

### **Install Dependencies**

```bash
pip install -r requirements.txt
```

### **Run Entire Pipeline**

```bash
bash run.sh
```

### **Manual Execution**

```bash
python src/data_loader.py
python src/preprocess.py
python src/train_svm.py
python src/train_rf.py
python src/evaluate.py
```

All scripts follow deterministic operations to ensure repeatable results.

---

## 🧑‍💻 10. Individual Contribution

This project includes the following contributions:

* Complete preprocessing pipeline
* SVM and Random Forest model implementation
* EDA (datasets, charts, sample visualizations)
* Hyperparameter exploration
* Evaluation and comparison
* Final report creation
* Presentation slides
* Version control and repository documentation

---

## 🔮 11. Future Work

* Implement **CNN-based digit classification** (Deep Learning)
* Use **PCA** for dimensionality reduction
* Perform **grid search / random search** for improved hyperparameters
* Add **data augmentation** to simulate real-world samples
* Explore **gradient boosting models**

---

## 📎 12. References

* Yann LeCun, “The MNIST Database”
* Scikit-Learn Documentation
* OpenML MNIST Dataset
* Cortes & Vapnik – SVM Foundations
* Breiman – Random Forests

---

