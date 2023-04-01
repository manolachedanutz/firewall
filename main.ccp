#include <iostream>
#include <vector>
#include <chrono>
#include <thread>
#include <algorithm>
#include <cstring>

using namespace std;

class Packet {
public:
    string source_ip;
    string dest_ip;
    int source_port;
    int dest_port;
    string protocol;
    string payload;
};

class Firewall {
public:
    bool is_allowed(Packet packet) {
        for (auto rule : rules) {
            if (rule.source_ip == packet.source_ip &&
                rule.dest_ip == packet.dest_ip &&
                rule.source_port == packet.source_port &&
                rule.dest_port == packet.dest_port &&
                rule.protocol == packet.protocol) {
                return rule.allowed;
            }
        }
        return default_rule.allowed;
    }

    void add_rule(string source_ip, string dest_ip, int source_port, int dest_port, string protocol, bool allowed) {
        Rule rule;
        rule.source_ip = source_ip;
        rule.dest_ip = dest_ip;
        rule.source_port = source_port;
        rule.dest_port = dest_port;
        rule.protocol = protocol;
        rule.allowed = allowed;
        rules.push_back(rule);
    }

    void remove_rule(int index) {
        if (index >= 0 && index < rules.size()) {
            rules.erase(rules.begin() + index);
        }
    }

    void set_default_rule(bool allowed) {
        default_rule.allowed = allowed;
    }

private:
    struct Rule {
        string source_ip;
        string dest_ip;
        int source_port;
        int dest_port;
        string protocol;
        bool allowed;
    };

    vector<Rule> rules;
    Rule default_rule = {"0.0.0.0", "0.0.0.0", 0, 0, "all", false};
};

void display_menu() {
    cout << "1. Add rule" << endl;
    cout << "2. Remove rule" << endl;
    cout << "3. Set default rule" << endl;
    cout << "4. View rules" << endl;
    cout << "5. Exit" << endl;
    cout << "Enter choice: ";
}

void display_rules(vector<Firewall::Rule> rules, Firewall::Rule default_rule) {
    cout << "Default rule: " << (default_rule.allowed ? "allow" : "block") << endl;
    cout << "Rules:" << endl;
    for (int i = 0; i < rules.size(); i++) {
        auto rule = rules[i];
        cout << i + 1 << ". " << rule.source_ip << " -> " << rule.dest_ip << " : " << rule.source_port << " -> " << rule.dest_port << " (" << rule.protocol << ") : " << (rule.allowed ? "allow" : "block") << endl;
    }
}

int main() {
    Firewall firewall;

    firewall.add_rule("192.168.1.2", "8.8.8.8", 1234, 80, "tcp", true);
    firewall.add_rule("10.0.0.1", "192.168.1.2", 443, 1234, "udp", false);
    firewall.set_default_rule(true);

    while (true) {
        display_menu();
        int choice;
        cin >> choice;

        if (choice == 1) {
            string source_ip, dest_ip, protocol;
            int source_port, dest_port;
            bool allowed;

            cout << "Enter source IP: ";
            cin >> source_ip;
            cout << "Enter destination IP: ";
            cin >> dest_ip;
            cout << "Enter source port: ";
            cin >> source
            cout << "Enter destination port: ";
            cin >> dest_port;
            cout << "Enter protocol: ";
            cin >> protocol;
            cout << "Allow (1) or Block (0)? ";
            cin >> allowed;

            firewall.add_rule(source_ip, dest_ip, source_port, dest_port, protocol, allowed);
            cout << "Rule added." << endl;
        }
        else if (choice == 2) {
            int index;
            display_rules(firewall.rules, firewall.default_rule);
            cout << "Enter index of rule to remove: ";
            cin >> index;
            firewall.remove_rule(index - 1);
            cout << "Rule removed." << endl;
        }
        else if (choice == 3) {
            bool allowed;
            cout << "Set default rule to Allow (1) or Block (0)? ";
            cin >> allowed;
            firewall.set_default_rule(allowed);
            cout << "Default rule set." << endl;
        }
        else if (choice == 4) {
            display_rules(firewall.rules, firewall.default_rule);
        }
        else if (choice == 5) {
            cout << "Exiting..." << endl;
            break;
        }
        else {
            cout << "Invalid choice." << endl;
        }

        cout << endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        system("clear");
    }

    return 0;
}
