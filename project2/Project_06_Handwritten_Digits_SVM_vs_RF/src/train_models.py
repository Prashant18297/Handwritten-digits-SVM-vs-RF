from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier
import time

def train_svm(X_train, y_train):
    print("Training SVM model...")
    start = time.time()
    svm_clf = SVC(kernel='rbf', gamma='scale')
    svm_clf.fit(X_train, y_train)
    end = time.time()
    print(f"SVM trained in {end - start:.2f} seconds.")
    return svm_clf, end - start


def train_rf(X_train, y_train):
    print("Training Random Forest model...")
    start = time.time()
    rf_clf = RandomForestClassifier(n_estimators=100, random_state=42)
    rf_clf.fit(X_train, y_train)
    end = time.time()
    print(f"Random Forest trained in {end - start:.2f} seconds.")
    return rf_clf, end - start
