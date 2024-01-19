//
//  ContentView.swift
//  GeminiHoroscope
//
//  Created by Anup D'Souza on 18/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var displayHoroscope = true
    @State private var fetchingHoroscope = false
    @State private var showingSigns = false
    @State private var showingStyles = false
    @State var currentSign: ZodiacSigns = .aquarius
    @State var currentStyle: HoroscopeStyle = .original
    @State var horoscope = ""

    var body: some View {
        VStack() {
            // MARK: Image
            zodiacSignImageView()
            
            // MARK: Title
            zodiacSignTitleView()
            
            // MARK: Horoscope
            zodiacSignHoroscopeView()
            
            VStack {
                // MARK: Sign select button
                zodiacSignButtonView()
                
                // MARK: Style select button
                horoscopeStyleButtonView()
                
                // MARK: Fetch horoscope button
                fetchHoroscopeButtonView()
            }
            .font(.title3.bold())
            .foregroundStyle(Color(.main))
            .buttonStyle(.borderedProminent)
            .tint(Color(.accent))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background {
            Color(.main)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder private func zodiacSignImageView() -> some View {
        Image(currentSign.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background {
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(.accent, lineWidth: 10)
            }
    }

    @ViewBuilder private func zodiacSignTitleView() -> some View {
        Text(currentSign.rawValue.uppercased())
            .font(.largeTitle)
            .foregroundStyle(Color(.accent))
    }

    @ViewBuilder private func zodiacSignHoroscopeView() -> some View {
        Text(currentSign.rawValue.uppercased())
            .font(.title3)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.all, 10)
    }

    @ViewBuilder private func zodiacSignButtonView() -> some View {
        Button(action: {
            showingSigns = true
        }, label: {
            HStack(spacing: 5) {
                if fetchingHoroscope {
                    Text("Loading...")
                    ProgressView()
                        .tint(Color(.main))
                } else {
                    Text("Sign: " + currentSign.rawValue.capitalized)
                }
            }
            .frame(width: 200)
        })
        .confirmationDialog("", isPresented: $showingSigns) {
            ForEach(ZodiacSigns.allCases, id: \.self) { sign in
                Button(sign.rawValue.capitalized) { selectedSign(sign) }
            }
        }
    }
    
    @ViewBuilder private func horoscopeStyleButtonView() -> some View {
        Button(action: {
            showingStyles = true
        }, label: {
            Text("Style: " + currentStyle.rawValue.capitalized)
                .frame(width: 200)
        })
        .confirmationDialog("", isPresented: $showingStyles) {
            ForEach(HoroscopeStyle.allCases, id: \.self) { style in
                Button(style.rawValue.capitalized) { selectedStyle(style) }
            }
        }
    }
    
    @ViewBuilder private func fetchHoroscopeButtonView() -> some View {
        Button(action: fetchHoroscope, label: {
            Text("Fetch Horoscope")
                .frame(width: 200)
        })
    }
    
    private func selectedSign(_ sign: ZodiacSigns) {
        currentSign = sign
    }
    
    private func selectedStyle(_ style: HoroscopeStyle) {
        currentStyle = style
    }
    
    private func fetchHoroscope() {
        // fetch horoscope
    }
}

#Preview {
    ContentView()
}
