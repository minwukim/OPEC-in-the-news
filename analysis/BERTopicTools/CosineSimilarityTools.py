import pandas as pd
import numpy as np
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

class CosineSimilarityTools:

    def __init__(self, topic_model, embedding_model_name='all-MiniLM-L6-v2'):
        self.topic_model = topic_model
        self.embedding_model = SentenceTransformer(embedding_model_name)
        self.topic_centroids = self._compute_centroids()

    def _compute_centroids(self):
        topics = self.topic_model.get_topics()
        topic_centroids = []

        for topic_num, topic_words in topics.items():
            word_vectors = [self.embedding_model.encode([word])[0] for word, _ in topic_words]
            centroid = np.mean(word_vectors, axis=0)
            topic_centroids.append(centroid)

        return topic_centroids

    def get_similarity_dataframe(self, word, sorted=False):
        word_vector = self.embedding_model.encode([word])[0]
        cosine_similarities = [cosine_similarity([word_vector], [centroid])[0][0] for centroid in self.topic_centroids]

        topics = self.topic_model.get_topics()
        data = []

        if sorted:
            sorted_indices = np.argsort(cosine_similarities)[::-1]
            for idx in sorted_indices:
                topic_num = list(topics.keys())[idx]
                similarity = cosine_similarities[idx]
                topic_words = topics[topic_num]
                words = ', '.join([word for word, _ in topic_words])
                data.append({"topic": topic_num, "topic_words": words, "cosine_similarity": similarity})
        else:
            for topic_num, topic_words in topics.items():
                idx = list(topics.keys()).index(topic_num)
                similarity = cosine_similarities[idx]
                words = ', '.join([word for word, _ in topic_words])
                data.append({"topic": topic_num, "topic_words": words, "cosine_similarity": similarity})

        return pd.DataFrame(data)

# # Usage example
# topic_similarity = CosineSimilarityTools(topic_model)
# df_similarity_sorted = topic_similarity.get_similarity_dataframe("demand", sorted=True)
# df_similarity_unsorted = topic_similarity.get_similarity_dataframe("demand", sorted=False)

