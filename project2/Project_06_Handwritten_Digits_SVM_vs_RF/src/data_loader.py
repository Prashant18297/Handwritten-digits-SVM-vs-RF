
from sklearn.datasets import fetch_openml

def load_mnist():
    """
    Loads the MNIST dataset from OpenML.
    Returns: (X, y)
    """
    print("Loading MNIST dataset...")
    X, y = fetch_openml('mnist_784', version=1, return_X_y=True, as_frame=False)
    y = y.astype(int)
    print(f"Dataset loaded: {X.shape[0]} samples, {X.shape[1]} features.")
    return X, y
