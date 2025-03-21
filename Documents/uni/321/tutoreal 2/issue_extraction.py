# issue_extraction.py
from transformers import pipeline

# Initialize the zero-shot classification pipeline using a pre-trained model
classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")

# Expanded set of candidate labels to cover various aspects of tutoring feedback
CANDIDATE_LABELS = [
    "pacing",         # How fast or slow the session was
    "clarity",        # Clarity of explanations
    "engagement",     # Student engagement and interactivity
    "communication",  # Effectiveness of communication
    "knowledge",      # Depth of subject knowledge
    "explanation",    # Quality and detail of explanations
    "friendliness",   # Tutor's demeanor and approachability
    "organization",   # Session structure and organization
    "tone",           # The tone or style of communication
    "preparation",    # How well-prepared the tutor was
    "responsiveness", # Tutor's ability to address questions
    "technical issues"  # Any technical difficulties during the session
]

def extract_issues(text: str, candidate_labels=CANDIDATE_LABELS, threshold: float = 0.3) -> list:
    """
    Extract issues from the feedback text using zero-shot classification.

    Args:
        text (str): The input feedback text.
        candidate_labels (list): A list of candidate issue labels.
        threshold (float): Confidence threshold to consider a label valid.

    Returns:
        list: A list of dictionaries, each containing an issue and its confidence score.
    """
    result = classifier(text, candidate_labels)
    
    # Debug: Print raw classifier output
    print("Raw classifier output:")
    print(result)
    
    issues = []
    for label, score in zip(result["labels"], result["scores"]):
        if score >= threshold:
            issues.append({"issue": label, "score": score})
    return issues

if __name__ == "__main__":
    # Example usage:
    test_text = "The tutor explained the concepts well but spoke too fast and sometimes wasn't clear. However, the session was engaging and the tutor was very friendly."
    issues_found = extract_issues(test_text)
    print("Extracted Issues:")
    for issue in issues_found:
        print(f"{issue['issue']} (score: {issue['score']:.2f})")
