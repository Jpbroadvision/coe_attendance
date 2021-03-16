class DataSource {
  static Map<String, Map<String, String>> _sessions = {
    "1": {"startTime": "08:30 am", "endTime": "10:30 am"},
    "2": {"startTime": "12:15 pm", "endTime": "2:15 pm"},
    "3": {"startTime": "4:00 pm", "endTime": "06:00 pm"},
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
