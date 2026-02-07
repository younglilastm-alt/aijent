# AIEvaluator.py

class AIEvaluator:
    def __init__(self, rules):
        self.rules = rules

    def evaluate(self, data):
        satisfying_rules = []
        for rule in self.rules:
            if self.check_rule(rule, data):
                satisfying_rules.append(rule)
        return satisfying_rules

    def check_rule(self, rule, data):
        # Implement the logic to check if the rule is satisfied by the data
        # This is just a placeholder for demonstration purposes.
        return True  # Replace with actual logic

# Example usage:
if __name__ == '__main__':
    rules = ['rule1', 'rule2', 'rule3']
    data = {'key': 'value'}
    evaluator = AIEvaluator(rules)
    print(evaluator.evaluate(data))
