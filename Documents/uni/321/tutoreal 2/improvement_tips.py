# improvement_tips.py

# Mapping of candidate issues to improvement suggestions.
# You can adjust or expand these as needed.
improvement_mapping = {
    "pacing": "Try slowing down and pausing for questions to ensure students keep up.",
    "clarity": "Consider using simpler language and more examples to explain complex concepts.",
    "engagement": "Incorporate more interactive elements and ask engaging questions during the session.",
    "communication": "Focus on clear and concise communication to avoid misunderstandings.",
    "knowledge": "Deepen your subject knowledge by reviewing additional resources before sessions.",
    "explanation": "Break down complex ideas into smaller, manageable parts for better understanding.",
    "friendliness": "Maintain a warm, approachable tone to make students feel comfortable.",
    "organization": "Structure your session with clear objectives and transitions between topics.",
    "tone": "Ensure your tone is supportive and positive to encourage student participation.",
    "preparation": "Prepare well in advance with notes and relevant examples to guide the session.",
    "responsiveness": "Be attentive and responsive to student questions throughout the session.",
    "technical issues": "Double-check your technical setup and ensure a stable connection before starting."
}

def generate_improvement_tip(issues: list) -> str:
    """
    Generate a combined improvement tip based on the extracted issues.
    
    Args:
        issues (list): A list of dictionaries containing detected issues 
                       (each dictionary should have an 'issue' key).
    
    Returns:
        str: A concatenated string of improvement suggestions.
    """
    tips = []
    for issue_dict in issues:
        issue = issue_dict.get("issue")
        tip = improvement_mapping.get(issue)
        if tip:
            tips.append(tip)
    # Join the tips with a space (or semicolon for clarity)
    return " ".join(tips) if tips else "No improvement suggestions available."

if __name__ == "__main__":
    # Example: Using a sample issues list (as returned by our issue extraction step)
    sample_issues = [
        {"issue": "pacing", "score": 0.75},
        {"issue": "clarity", "score": 0.65},
        {"issue": "engagement", "score": 0.55}
    ]
    improvement_tip = generate_improvement_tip(sample_issues)
    print("Improvement Tip:")
    print(improvement_tip)
