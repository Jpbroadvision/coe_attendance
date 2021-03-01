class DataSource {
  static Map<String, Map<String, String>> _sessions = {
    "1": {"startTime": "08:15 am", "endTime": "09:15 am"},
    "2": {"startTime": "10:15 am", "endTime": "11:15 am"},
    "3": {"startTime": "12:15 pm", "endTime": "13:15 pm"},
    "4": {"startTime": "14:15 pm", "endTime": "15:15 pm"},
    "5": {"startTime": "16:15 pm", "endTime": "17:15 pm"},
    "6": {"startTime": "18:15 pm", "endTime": "19:15 pm"},
    "7": {"startTime": "19:30 pm", "endTime": "20:30 pm"},
  };

  static Map<String, List<String>> getAllocations() => {
        "LT": ["Alfred Crabbe AE"],
        "RMA": ["Benjamin Asare CHE"],
        "RMB": ["Elvis Yeboah"],
        "206": ["Ezekiel Nettey-Oppong MSE"],
        "303": ["Franklin Bartels EE "],
        "304": ["Ignace Kodjo CHE"],
        "LH": ["Jephter Fordjour CE "],
        "VSLA": ["Justice Kwamena COE", "Janet Baffoe"],
        "PB001": ["Komla Wilson COE", "Etornam Tsyaw"],
        "PB020": ["Godson Nyaforkpa MSE", "Alice Kwateng EE"],
        "PB014": ["Nana Ofosu Asante EE", "Constance Adomako"],
        "PB012": ["Opoku-Mensah GEOM", "Owusu Sarpong"],
        "PB008": ["Oppong Kyekyeku AE"],
        "PB201": ["Solomon Apafo CE", "Edwina Ampadu CHE"],
        "PB214": ["Elijah Effah MSE", "Deborah Adoma"],
        "PB212": ["Awudu Yussif EE", "Obed Asare GEOM"],
        "PB208": ["Courage Jahmon GEOM", "Victor Elikem CoE"],
        "N1": ["Fortunatus TELE"],
        "N2": ["Israel Mark ME"],
        "VCR": ["Micheal Etorko PETE"],
        "ECR": ["Prince Henry METE"],
        "EA": ["Mohammed Abdul-Jaleel METE", "Freda Quaye MSE"],
        "A110": ["Opoku Clement METE", "Anita Broni AE"],
        "FOSSB4": [
          "Isaac Owusu Dapaah MSE",
          "Kanyomse Albright EE",
          "Eric Asante"
        ],
        "FOSSB3": ["Lord Wiafe EE", "Ahmed Abdul Nasir MSE "],
        "FOSSGF9": ["Joshua Adu MSE", "Micheal Coleman ME", "Enoch Aning GEOM"],
        "FOSSGF8": ["Jacklingo Quansah COE", "Kobena Badu EE", "Aduamah Isaac"]
      };

  static Map<String, String> getSession(String sessionNumber) =>
      _sessions[sessionNumber];
}
