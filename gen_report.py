# automates report creation
import os
import natsort

def main(dir_name, report_name):
    with open(report_name, "w+") as f:
        f.write("--------------------\n")
        f.write("DUT REPORT\n")
        f.write("--------------------\n")

        logs = os.listdir(dir_name)
        logs = natsort.natsorted(logs)
        for logfile in logs:
            with open("./logs/"+logfile, "r") as l:
                content = l.read()
                if "[ERROR: COMPARATOR]" in content:
                    f.write(f"{logfile.replace(".log", "")}: ERROR\n")
                    print(f"{logfile.replace(".log", "")}: ERROR")
                else:
                    f.write(f"{logfile.replace(".log", "")}: PASS\n")
                    print(f"{logfile.replace(".log", "")}: PASS")

if __name__ == "__main__":
    main("./logs", "README.md")
