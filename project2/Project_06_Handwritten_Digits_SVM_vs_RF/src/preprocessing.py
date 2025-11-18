from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

def preprocess_data(X, y, test_size=0.2, random_state=42):
    """
    Scales and splits the data into training and test sets.
    """
    print("Preprocessing data...")
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y, test_size=test_size, random_state=random_state
    )
    print(f"Train size: {X_train.shape}, Test size: {X_test.shape}")
    return X_train, X_test, y_train, y_test
