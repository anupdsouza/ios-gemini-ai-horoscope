//
//  ContentView.swift
//  GeminiHoroscope
//
//  Created by Anup D'Souza on 18/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSigns = false
    @State private var showingStyles = false
    @State private var showHoroscope = false
    @State private var fetchingHoroscope = false
    @State private var currentSign: ZodiacSigns = .aquarius
    @State private var currentStyle: HoroscopeStyle = .original
    @State private var horoscope: Horoscope?
    @Namespace private var namespace

    var body: some View {
        ZStack {
            VStack {
                
                // MARK: Horoscope elements
                
                zodiacSignImageView()
                    .matchedGeometryEffect(id: "image", in: namespace)
                    .frame(width: showHoroscope ? 100 : 200)
                    .padding(.top, showHoroscope ? 80 : 0)
                    .onTapGesture {
                        if showHoroscope {
                            withAnimation {
                                showHoroscope.toggle()
                            }
                        }
                    }
                
                zodiacSignTitleView()
                    .matchedGeometryEffect(id: "title", in: namespace)
                
                if showHoroscope {
                    zodiacSignHoroscopeView()
                }
                                
                // MARK: Buttons
                VStack {
                    zodiacSignButtonView()
                    
                    horoscopeStyleButtonView()
                    
                    fetchHoroscopeButtonView()
                }
                .font(.title3.bold())
                .foregroundStyle(Color(.main))
                .buttonStyle(.borderedProminent)
                .tint(Color(.accent))
                .offset(y: showHoroscope ? UIScreen.main.bounds.size.height : 0)
                .transition(.slide)
                .animation(.spring(dampingFraction: 0.8), value: showHoroscope)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.background)
                .resizable()
                .scaledToFill()
            Color(.main)
                .opacity(0.9)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Zodiac image
    @ViewBuilder private func zodiacSignImageView() -> some View {
        Image(currentSign.rawValue)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: showHoroscope ? 10 : 20))
            .background {
                RoundedRectangle(cornerRadius: showHoroscope ? 10 : 20)
                    .stroke(.accent, lineWidth: showHoroscope ? 5 : 10)
            }
    }

    // MARK: Zodiac title
    @ViewBuilder private func zodiacSignTitleView() -> some View {
        Text(currentSign.rawValue.uppercased())
            .font(.largeTitle)
            .foregroundStyle(Color(.accent))
    }

    // MARK: Zodiac horoscope
    @ViewBuilder private func zodiacSignHoroscopeView() -> some View {
        if let horoscope = horoscope?.horoscope_data {
            ScrollView(.vertical) {
                Text(horoscope)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
            }
        }
    }

    // MARK: Sign select button
    @ViewBuilder private func zodiacSignButtonView() -> some View {
        Button(action: {
            showingSigns = true
        }, label: {
            Text("Sign: " + currentSign.rawValue.capitalized)
                .frame(width: 200)
        })
        .confirmationDialog("", isPresented: $showingSigns) {
            ForEach(ZodiacSigns.allCases, id: \.self) { sign in
                Button(sign.rawValue.capitalized) { selectedSign(sign) }
            }
        }
    }
    
    // MARK: Style select button
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
    
    // MARK: Fetch horoscope button
    @ViewBuilder private func fetchHoroscopeButtonView() -> some View {
        Button(action: {
            Task {
                await fetchHoroscope()
            }
        }, label: {
            Group {
                if fetchingHoroscope {
                    HStack(spacing: 5) {
                        Text("Loading...")
                        ProgressView()
                            .tint(Color(.main))
                    }
                } else {
                    Text("Fetch Horoscope")
                }
            }
            .frame(width: 200)
        })
    }
    
    private func selectedSign(_ sign: ZodiacSigns) {
        currentSign = sign
    }
    
    private func selectedStyle(_ style: HoroscopeStyle) {
        currentStyle = style
    }
    
    // MARK: Make request
    private func fetchHoroscope() async {
        fetchingHoroscope = true
        do {
            let url = URL(string: "https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=\(currentSign.rawValue)&day=today")!
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let horoscopeResponse = try JSONDecoder().decode(HoroscopeResponse.self, from: data)
            fetchingHoroscope = false
            // TODO: If horoscope style != original, request gemini for summary with tonal style
            await MainActor.run {
                self.horoscope = horoscopeResponse.data
                withAnimation {
                    showHoroscope = true
                }
            }
        }
        catch {
            fetchingHoroscope = false
            showHoroscope = false
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
