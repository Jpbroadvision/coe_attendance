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
        "LT": ["Alfred Crabbe"],
        "RMA": ["Benjamin Asare"],
        "RMB": ["Elvis Yeboah"],
        "206": ["Ezekiel Nettey-Oppong"],
        "303": ["Franklin Bartels "],
        "304": ["Ignace Kodjo"],
        "LH": ["Jephter Fordjour "],
        "VSLA": ["Justice Kwamena", "Janet Baffoe"],
        "PB001": ["Komla Wilson", "Etornam Tsyaw"],
        "PB020": ["Godson Nyaforkpa", "Alice Kwateng"],
        "PB014": ["Nana Ofosu Asante", "Constance Adomako"],
        "PB012": ["Opoku-Mensah", "Owusu Sarpong"],
        "PB008": ["Oppong Kyekyeku"],
        "PB201": ["Solomon Apafo", "Edwina Ampadu"],
        "PB214": ["Elijah Effah", "Deborah Adoma"],
        "PB212": ["Awudu Yussif", "Obed Asare"],
        "PB208": ["Courage Jahmon", "Victor Elikem"],
        "N1": ["Fortunatus"],
        "N2": ["Israel Mark"],
        "VCR": ["Micheal Etorko PETE"],
        "ECR": ["Prince Henry METE"],
        "EA": ["Mohammed Abdul-Jaleel METE", "Freda Quaye"],
        "A110": ["Opoku Clement METE", "Anita Broni"],
        "FOSSB4": ["Isaac Owusu Dapaah", "Kanyomse Albright", "Eric Asante"],
        "FOSSB3": ["Lord Wiafe", "Ahmed Abdul Nasir "],
        "FOSSGF9": ["Joshua Adu", "Micheal Coleman", "Enoch Aning"],
        "FOSSGF8": ["Jacklingo Quansah", "Kobena Badu", "Aduamah Isaac"]
      };

  static Map<String, String> getSession(String sessionNumber) =>
      _sessions[sessionNumber];
}
