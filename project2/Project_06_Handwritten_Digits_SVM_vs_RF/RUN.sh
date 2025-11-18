#!/usr/bin/env bash
# run.sh - reproducible runner for Handwritten_Digits_SVM_vs_RF project
# Usage:
#   ./run.sh setup        -> create venv and install requirements
#   ./run.sh download     -> download MNIST (via sklearn/openml) and create data placeholder
#   ./run.sh train-svm    -> train SVM model
#   ./run.sh train-rf     -> train Random Forest model
#   ./run.sh evaluate     -> generate evaluation (confusion matrices, reports)
#   ./run.sh all          -> run setup, download, train both models and evaluate
#   ./run.sh clean        -> remove venv, __pycache__, outputs (use with caution)
#
# Notes:
# - This script assumes you have python3 installed on your system.
# - It creates a virtual environment in .venv/ by default.
# - Put your Python scripts or notebooks in the following structure (suggested):
#     src/data_loader.py
#     src/preprocess.py
#     src/train_svm.py
#     src/train_rf.py
#     src/evaluate.py
#
set -euo pipefail
VENV_DIR=".venv"
PYTHON="${VENV_DIR}/bin/python"
PIP="${VENV_DIR}/bin/pip"
REQUIREMENTS_FILE="requirements.txt"
SRC_DIR="src"
RESULTS_DIR="results"
DATA_DIR="data"

mkdir -p "${RESULTS_DIR}"
mkdir -p "${DATA_DIR}"

function show_help() {
    sed -n '1,120p' "$0"
}

case "${1:-help}" in
    setup)
        if [ -d "$VENV_DIR" ]; then
            echo "Virtual environment already exists at ${VENV_DIR}."
        else
            echo "Creating virtual environment in ${VENV_DIR}..."
            python3 -m venv "${VENV_DIR}"
        fi
        echo "Upgrading pip..."
        "${PIP}" install --upgrade pip
        if [ -f "${REQUIREMENTS_FILE}" ]; then
            echo "Installing requirements from ${REQUIREMENTS_FILE}..."
            "${PIP}" install -r "${REQUIREMENTS_FILE}"
        else
            echo "No ${REQUIREMENTS_FILE} found. Installing common ML packages..."
            "${PIP}" install numpy scikit-learn matplotlib pandas seaborn jupyter
        fi
        echo "Setup complete."
        ;;
    download)
        echo "Downloading MNIST (using sklearn/openml inside Python)..."
        "${PYTHON}" - <<PYCODE
from sklearn.datasets import fetch_openml
import numpy as np, os
os.makedirs("${DATA_DIR}", exist_ok=True)
print("Fetching MNIST (this may take a while)...")
mnist = fetch_openml('mnist_784', version=1, as_frame=False)
X, y = mnist['data'], mnist['target'].astype(int)
np.save(os.path.join("${DATA_DIR}", "X.npy"), X)
np.save(os.path.join("${DATA_DIR}", "y.npy"), y)
with open(os.path.join("${DATA_DIR}", "README.txt"), "w") as f:
    f.write("MNIST fetched from OpenML. X.npy -> features (N x 784), y.npy -> labels (N,).\\n")
print("MNIST saved to ${DATA_DIR}/X.npy and ${DATA_DIR}/y.npy")
PYCODE
        echo "Download complete."
        ;;
    train-svm)
        echo "Training SVM model..."
        if [ -x "${PYTHON}" ]; then
            "${PYTHON}" "${SRC_DIR}/train_svm.py"
        else
            echo "Python venv not found. Run './run.sh setup' first."
            exit 1
        fi
        echo "SVM training finished (check ${RESULTS_DIR} for outputs)."
        ;;
    train-rf)
        echo "Training Random Forest model..."
        if [ -x "${PYTHON}" ]; then
            "${PYTHON}" "${SRC_DIR}/train_rf.py"
        else
            echo "Python venv not found. Run './run.sh setup' first."
            exit 1
        fi
        echo "Random Forest training finished (check ${RESULTS_DIR} for outputs)."
        ;;
    evaluate)
        echo "Running evaluation script..."
        if [ -x "${PYTHON}" ]; then
            "${PYTHON}" "${SRC_DIR}/evaluate.py"
        else
            echo "Python venv not found. Run './run.sh setup' first."
            exit 1
        fi
        echo "Evaluation complete. See ${RESULTS_DIR}."
        ;;
    all)
        echo "Full pipeline: setup -> download -> train both -> evaluate"
        "$0" setup
        "$0" download
        "$0" train-svm
        "$0" train-rf
        "$0" evaluate
        echo "Pipeline finished."
        ;;
    clean)
        echo "Cleaning project artifacts..."
        rm -rf "${VENV_DIR}"
        rm -rf "${RESULTS_DIR}"
        find . -type d -name '__pycache__' -exec rm -rf {} +
        echo "Cleaned."
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: ${1:-}"
        echo "Usage: $0 {setup|download|train-svm|train-rf|evaluate|all|clean|help}"
        exit 2
        ;;
esac
