import SwiftUI

struct CharacterIntroView: View {
    let characters = Character.allCharacters
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.05), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Meet Your Sorting Team")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(characters) { char in
                            CharacterCard(character: char)
                        }
                    }
                    .padding()
                }
                
                NavigationLink(destination: SortingArenaView()) {
                    Text("Enter Sorting Arena")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding()
                }
            }
        }
    }
}

struct CharacterCard: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: character.iconName)
                .font(.system(size: 40))
                .foregroundColor(character.color)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(character.name)
                    .font(.title3.bold())
                Text(character.role)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\"\(character.catchphrase)\"")
                    .font(.caption.italic())
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
