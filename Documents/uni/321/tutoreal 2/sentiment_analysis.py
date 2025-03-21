# sentiment_analysis.py
from transformers import pipeline

# Initialize the sentiment analysis pipeline using a pre-trained model
sentiment_pipeline = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")

def analyze_sentiment(text: str) -> dict:
    """
    Analyze the sentiment of the given text.

    Args:
        text (str): The input feedback text.

    Returns:
        dict: A dictionary containing the sentiment label and confidence score.
              Example: {'label': 'POSITIVE', 'score': 0.998}
    """
    result = sentiment_pipeline(text)
    return result[0]

if __name__ == "__main__":
    # Test the sentiment analysis function
    test_text = "The tutor was great but spoke too fast."
    sentiment = analyze_sentiment(test_text)
    print(f"Sentiment analysis result: {sentiment}")
