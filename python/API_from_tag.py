#
import sys

def API_filter(file_name):
    API_file_name = file_name.split(".")[0] + "_API" + ".log"
    API_file = open(API_file_name, "w")
    API_file.close()
    try:
        with open(file_name, "r") as file:
            for r in file:
                is_exist = False
                with open(API_file_name, "r") as save_file:
                    for sr in save_file:
                        try:
                            if r.split(";")[1] == sr:
                                is_exist = True
                                break
                        except:
                            is_exist = True
                            break
                    if not is_exist:
                        save_file.close()
                        save_file = open(API_file_name, "a+")
                        try:
                            save_file.writelines(r.split(";")[1])
                            print("write lines: " + r.split(";")[1])
                        except:
                            save_file.writelines(r)
                            print(r)
                        finally:
                            save_file.close()

    except Exception as e:
        print("error: " + str(e))
    else:
        print("success")

if __name__ == '__main__':
    if(len(sys.argv) != 2):
        print("use python3 API_from_tag.py your_tag_filename")
    else:
        tag_file = sys.argv[1]
        print("get API from file: " + tag_file)
        API_filter(tag_file)
