import json

class AIEvaluator:
    def __init__(self):
        pass

    def evaluate_withdrawal_rules(self, criteria):
        """Evaluates withdrawal rules based on provided criteria."""
        decisions = {
            "withdraw":"allowed",
            "reason":"meets withdrawal conditions"
        }
        # Logic for evaluation goes here
        return decisions

    def evaluate_conditional_sell_rules(self, market_conditions):
        """Evaluates sell rules based on market conditions."""
        decisions = {
            "sell":"denied",
            "reason":"conditions not met"
        }
        # Logic for evaluation goes here
        return decisions

    def detect_panic_patterns(self, market_data):
        """Detects panic patterns in market data."""
        patterns_detected = []
        # Logic for detecting panic patterns goes here

        if len(patterns_detected) > 0:
            return {"panic_detected": True, "patterns": patterns_detected}
        return {"panic_detected": False}

    def make_decision(self, withdrawal_criteria, sell_conditions, market_data):
        """Returns structured JSON decisions based on evaluations."""
        withdrawal_decision = self.evaluate_withdrawal_rules(withdrawal_criteria)
        sell_decision = self.evaluate_conditional_sell_rules(sell_conditions)
        panic_decision = self.detect_panic_patterns(market_data)
        return json.dumps({
            "withdrawal_decision": withdrawal_decision,
            "sell_decision": sell_decision,
            "panic_decision": panic_decision
        }, indent=4)
