# CLAUDE.md — Flutter Team Config

> **İlk eylem:** `.claude/state.md` oku. Varsa → devam et. Yoksa → ADIM 0'a geç.

---

## Proje

| Alan | Değer |
|---|---|
| Platform | Flutter |
| State Mgmt | _(doldur: BLoC / Riverpod / Provider)_ |
| Mimari | _(doldur: Clean / Feature-first / Layer-first)_ |
| Main branch | `main` |
| Feature prefix | `feature/` |
| Fix prefix | `fix/` |

---

## State Dosyası — `.claude/state.md`

Her görev sonunda bu dosyayı **yaz/güncelle**. Her oturum başında **oku**.

```markdown
# State
task: <görev adı>
branch: <mevcut branch>
step: <Developer|UITest|Review|Done>
iteration: <1-3>
status: <active|blocked|done>
last_note: <son agent'ın tek satır özeti>
updated: <tarih>
```

**Kurallar:**
- `step: Done` + `status: done` → görev bitti, push onayı bekleniyor.
- `status: blocked` → iterasyon 3'te geçilemedi, kullanıcıyı bildir.
- Oturum başında state varsa: "Kaldığım yerden devam edeyim mi?" diye sor.

---

## Agents

Her agent kendi SKILL dosyasını okur — içerik burada **tekrar edilmez** (token tasarrufu).

| # | Agent | SKILL | Tetikleyici |
|---|---|---|---|
| 1 | Developer | `.claude/developer_SKILL.md` | Görev başlangıcı |
| 2 | UI/UX Test | `.claude/uiux_test_SKILL.md` | Developer tamamlandı |
| 3 | Review | `.claude/review_SKILL.md` | UITest geçti |

---

## Akış

```
[Oturum başı] → state.md oku
      ↓
[ADIM 0] Görev tipi sor (yeni/fix/mevcut)
      ↓
[ADIM 1] Developer  →  state: step=Developer
      ↓
[ADIM 2] UI/UX Test →  state: step=UITest
      ↓                  ↑ başarısız (iter++)
[ADIM 3] Review     →  state: step=Review
      ↓ ≥75 puan         ↑ başarısız (iter++)
[Push onayı] → state: step=Done
```

- Başarısız döngü **max 3 iterasyon**. Aşılırsa → `status: blocked`, kullanıcıyı bildir, dur.
- Her adım sonunda `state.md` güncelle.

---

## ADIM 0 — Görev Tipi

```
Bu görev ne tür?
  [1] Yeni özellik   → git checkout -b feature/<isim>
  [2] Hata düzeltme  → git checkout -b fix/<isim>
  [3] Mevcut branch  → branch açma
```

---

## Genel Kurallar

- Push → sadece kullanıcı onayıyla. `main`'e direkt push yok.
- Her commit = tek mantıksal değişiklik.
- `flutter analyze` → hata varsa dur.
- API key / secret kaynak kodda olmaz.
- Test dosyaları silinmez, skip edilmez.
- `lib/` mimarisini analiz et, birebir uy.

---

## Yeniden Kullanım

1. Bu `CLAUDE.md` + `.claude/` klasörünü yeni projeye kopyala.
2. **Proje** tablosunu güncelle.
3. `.claude/state.md` yoksa oluşturma — ilk görevde otomatik yaratılır.
