import pandas as pd
from sklearn.model_selection import train_test_split

from salmon.triplets.offline import OfflineEmbedding

# Read in data
df = pd.read_csv("EmbeddingData/FullSet_cleaned.csv")  # from dashboard
# em = pd.read_csv("embedding.csv")  # from dashboard; optional

X = df[["head", "winner", "loser"]].to_numpy()
X_train, X_test = train_test_split(X, random_state=42, test_size=0.2)

n = int(X.max() + 1)  # number of targets
d = 6  # embed into # of dimensions

# Fit the model
model = OfflineEmbedding(n=n, d=d, max_epochs=20_000)
# model.initialize(X_train, embedding=em.to_numpy())  # (optional)

model.fit(X_train, X_test)

# Inspect the model
model.embedding_  # embedding
model.history_  # to view information on how well train/test performed

embs = pd.DataFrame(model.embedding_)
print("Saving embeddings to CSV...")
embs.to_csv("EmbeddingData/triplet_textures_groupEmb_6d.csv")
#embs.to_csv("Variance/VarianceEmbeddings/triplet_textures_full_set_groupEmb_3d.csv")
print("CSV saved.")

 # Assuming model.history_ is a list of dictionaries, each representing a record
history = model.history_  # Replace this with the actual structure of model.history_

# Convert history to a pandas DataFrame
df_history = pd.DataFrame(history)

# Save DataFrame to CSV (customize the filename as needed)
df_history.to_csv("history_logFull_6d.csv", index=False)

print("Training history saved to CSV.") 