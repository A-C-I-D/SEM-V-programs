#include <iostream>
using namespace std;

void fifoScheduling(int processes[], int n, int burst_time[], int arrival_time[]) {
    int waiting_time[n], turnaround_time[n], start_time[n], finish_time[n];
    waiting_time[0] = 0;
    start_time[0] = arrival_time[0];
    finish_time[0] = start_time[0] + burst_time[0];
    for (int i = 1; i < n; i++) {
        start_time[i] = max(finish_time[i-1], arrival_time[i]);
        waiting_time[i] = start_time[i] - arrival_time[i];
        if (waiting_time[i] < 0) waiting_time[i] = 0;
        finish_time[i] = start_time[i] + burst_time[i];
    }
    for (int i = 0; i < n; i++)
        turnaround_time[i] = waiting_time[i] + burst_time[i];

    for (int i = 0; i < n; i++) {
        cout << "Process " << processes[i] << ":\n";
        cout << "  Arrival Time   : " << arrival_time[i] << endl;
        cout << "  Burst Time     : " << burst_time[i] << endl;
        cout << "  Start Time     : " << start_time[i] << endl;
        cout << "  Execution Time : " << finish_time[i] << endl;
        cout << "  Waiting Time   : " << waiting_time[i] << endl;
        cout << "  Turnaround Time: " << turnaround_time[i] << endl;
        cout << endl;
    }
}

int main() {
    int n;
    cout << "Enter number of processes: ";
    cin >> n;
    int processes[n], burst_time[n], arrival_time[n];
    for (int i = 0; i < n; i++) {
        processes[i] = i + 1;
        cout << "Process " << processes[i] << ":\n";
        cout << "  Enter arrival time: ";
        cin >> arrival_time[i];
        cout << "  Enter burst time: ";
        cin >> burst_time[i];
    }
    fifoScheduling(processes, n, burst_time, arrival_time);
    return 0;
}
