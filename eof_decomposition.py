# %%
# %%
import numpy as np
import pandas as pd

class EOFDecomposition:
    """
    A class that performs Empirical Orthogonal Function (EOF) decomposition on ADCIRC fort.63 or fort.61 files.

    Attributes:
        data_matrix (numpy array): Matrix of shape (nodes x time) containing water elevation data.
        L (numpy array): Leading EOF eigenvectors (nodes x r).
        U (numpy array): Diagonal matrix of retained eigenvalues (r x r).
        explained_variance (numpy array): Fraction of variance explained by each EOF mode.
    """

    def __init__(self, filename):
        """
        Initializes the EOFDecomposition class by reading the ADCIRC fort.63 file.
        
        Parameters:
            filename (str): Path to the fort.63 file.
        """
        self.filename = filename
        self.data_matrix = self.load_csv(self.filename)
        self.L = None  # Eigenvectors (EOFs)
        self.U = None  # Diagonal eigenvalues matrix
        self.explained_variance = None  # Explained variance of each mode
        self.total_variance = None
        self.P = None

   
    def load_csv(self, csv_filename):
        """
        Loads a data matrix from a CSV file and assigns it to the `data_matrix` attribute.
        
        Parameters:
            csv_filename (str): Path to the CSV file containing the matrix.
        """
        self.data_matrix = np.genfromtxt(csv_filename, delimiter=',')

        nan_rows = np.isnan(self.data_matrix).any(axis=1)
        print("Rows with NaN values:", np.where(nan_rows)[0])

        # if np.isnan(self.data_matrix).any():
        #     self.data_matrix = self.data_matrix[~np.isnan(self.data_matrix).any(axis=1)]
        #     print(f"NaN rows removed. New shape: {self.data_matrix.shape}")

        # Replace NaN rows by copying the previous row
        for i in range(1, len(self.data_matrix)):
            if nan_rows[i]:
                self.data_matrix[i] = self.data_matrix[i - 1]

        print(f"Data matrix loaded from {csv_filename}. Shape: {self.data_matrix.shape}")


    def compute_eof(self, r=None, variance_threshold=0.9):
        """
        Performs EOF decomposition on the data matrix.

        Parameters:
            r (int, optional): Number of EOF modes to retain. If None, uses variance_threshold.
            variance_threshold (float): Percentage of total variance to retain.

        Returns:
            None (updates class attributes: L, U, explained_variance)
        """
        # Step 1: Remove mean across time
        X = self.data_matrix - np.mean(self.data_matrix, axis=1, keepdims=True)

        # Step 2: Compute sample covariance matrix
        N = X.shape[1]  # Number of time steps
        P = (1 / (N - 1)) * X @ X.T  # Sample covariance matrix
        self.P = P

        # Step 3: Eigenvalue decomposition
        eigenvalues, eigenvectors = np.linalg.eigh(P)  # Use eigh (since P is symmetric)

        # Step 4: Sort eigenvalues and eigenvectors in descending order
        sorted_indices = np.argsort(eigenvalues)[::-1]
        eigenvalues = eigenvalues[sorted_indices]
        eigenvectors = eigenvectors[:, sorted_indices]

        # Step 5: Determine number of EOFs to retain
        total_variance = np.sum(eigenvalues)
        self.total_variance = total_variance
        explained_variance = np.cumsum(eigenvalues) / total_variance

        if r is None:
            r = np.argmax(explained_variance >= variance_threshold) + 1  # Retain enough modes

        # Store results in class attributes
        self.L = eigenvectors[:, :r]
        self.U = np.diag(eigenvalues[:r])
        self.explained_variance = explained_variance[:r]


    def get_eofs(self):
        """
        Returns the leading EOFs (L) and eigenvalues (U).

        Returns:
            tuple: (L, U) where L is (nodes x r) matrix of EOFs and U is (r x r) diagonal matrix of eigenvalues.
        """
        if self.L is None or self.U is None:
            raise ValueError("EOF decomposition has not been computed yet. Call compute_eof() first.")
        return self.L, self.U

    def get_variance_explained(self):
        """
        Returns the variance explained by the retained EOFs.

        Returns:
            numpy array: Explained variance for each retained EOF mode.
        """
        if self.explained_variance is None:
            raise ValueError("EOF decomposition has not been computed yet. Call compute_eof() first.")
        return self.explained_variance


# %%%
eof = EOFDecomposition(filename='data/tides30k.csv')
data_matrix = eof.load_csv('data/tides30k.csv')


# %%
# Perform EOF decomposition

eof.compute_eof(r=288)

# Display the Leading EOFs (L)
L, _ = eof.get_eofs()  # Get the EOFs (L) and eigenvalues (U)
print("Leading EOFs (L):")
print(L)

# Display the Eigenvalues (U)
_, U = eof.get_eofs()  # U is the eigenvalues matrix
print("\nEigenvalues (U):")
print(U)

# Display the Explained Variance
explained_variance = eof.get_variance_explained()
print("\nExplained Variance:")
print(explained_variance)


# %%
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# You can visualize the cumulative explained variance for each EOF mode. This helps 
# understand how much variance each EOF mode explains and how quickly the variance is captured as you add more modes.

plt.figure(figsize=(8, 6))
plt.plot(np.arange(1, len(explained_variance) + 1), explained_variance * 100, marker='o', linestyle='-', color='b')
plt.title('Explained Variance by EOF Modes')
plt.xlabel('EOF Mode')
plt.ylabel('Explained Variance (%)')
plt.grid(True)
plt.show()

# Assume the EOF time series is the projection of the data onto the EOFs
# Compute the projections (e.g., X * L)
EOF_time_series = np.dot(L.T, eof.data_matrix)

# Plot time series of the first few EOFs To understand the temporal behavior 
# of the leading EOFs, you can plot the time series for each retained EOF mode.
# The time series represents how each mode evolves over time.
plt.figure(figsize=(8, 6))
for i in range(min(5, L.shape[1])):  # Plot first 5 EOFs
    plt.plot(EOF_time_series[i], label=f'EOF Mode {i+1}')
plt.title('Time Series of Leading EOF Modes')
plt.xlabel('Time Step')
plt.ylabel('Amplitude')
plt.legend()
plt.grid(True)
plt.show()

# A scree plot shows the eigenvalues of the EOF decomposition in descending order.
# This gives you a sense of how the variance is distributed among the different modes.
plt.figure(figsize=(8, 6))
plt.plot(np.arange(1, len(explained_variance) + 1), np.diag(eof.U), marker='o', linestyle='-', color='r')
plt.title('Eigenvalue Spectrum (Scree Plot)')
plt.xlabel('EOF Mode')
plt.ylabel('Eigenvalue (Variance)')
plt.grid(True)
plt.show()

# Bar chart of explained variance
plt.figure(figsize=(8, 6))
plt.bar(np.arange(1, len(explained_variance) + 1), explained_variance * 100, color='b')
plt.title('Variance Explained by Each EOF Mode')
plt.xlabel('EOF Mode')
plt.ylabel('Explained Variance (%)')
plt.show()

# Cumulative sum of explained variance. An elbow plot helps you identify the point at which adding 
# more EOF modes contributes very little to the explained variance. It can guide you in selecting 
# the optimal number of modes.
cumulative_variance = np.cumsum(explained_variance)

plt.figure(figsize=(8, 6))
plt.plot(np.arange(1, len(cumulative_variance) + 1), cumulative_variance * 100, marker='o', linestyle='-', color='g')
plt.title('Cumulative Explained Variance')
plt.xlabel('Number of EOF Modes')
plt.ylabel('Cumulative Explained Variance (%)')
plt.grid(True)
plt.show()

# Plot histograms of the first few EOF modes
plt.figure(figsize=(8, 6))
for i in range(min(5, L.shape[1])):  # Plot first 5 EOFs
    plt.hist(L[:, i], bins=30, alpha=0.5, label=f'EOF Mode {i+1}')
plt.title('Histogram of EOF Mode Distributions')
plt.xlabel('EOF Amplitude')
plt.ylabel('Frequency')
plt.legend()
plt.show()



